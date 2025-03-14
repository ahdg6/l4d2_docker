# syntax=docker/dockerfile:1.2

# ========= Stage 1: Builder 阶段 =========
FROM debian:12-slim AS builder
LABEL org.opencontainers.image.source="https://github.com/HoshinoRei/l4d2server-docker"
LABEL L4D2_VERSION=2243

# 基础环境变量
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# 明确指定各路径，避免变量嵌套引用失效
ENV STEAM_USER=steam
ENV HOME_DIR=/home/steam
ENV SERVER_DIR=/home/steam/l4d2server
ENV GAME_DIR=/home/steam/l4d2server/left4dead2
ENV STEAMCMD_DIR=/home/steam/steamcmd

# 可选：从外部获取 Steam 凭证（如果需要登录非匿名）
ARG STEAM_USERNAME_ARG=""
ARG STEAM_PASSWORD_ARG=""

# 安装构建所需依赖，创建 steam 用户
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        lib32gcc-s1 \
        ca-certificates \
        bash && \
    adduser --home "${HOME_DIR}" --disabled-password --shell /bin/bash --gecos "user for running steam" --quiet "${STEAM_USER}" && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 切回 root，创建缓存目录并赋予权限
USER root
RUN mkdir -p /steamcmd-cache && chown "${STEAM_USER}":"${STEAM_USER}" /steamcmd-cache

# 生成 fallback 凭证文件，并改回 steam 用户
USER "${STEAM_USER}"
WORKDIR "${HOME_DIR}"
RUN echo "${STEAM_USERNAME_ARG}" > "${HOME_DIR}/steam_username_fallback" && \
    echo "${STEAM_PASSWORD_ARG}" > "${HOME_DIR}/steam_password_fallback"

# 缓存 steamcmd 并解压
RUN --mount=type=cache,target=/steamcmd-cache,uid=1000,gid=1000 \
    if [ ! -f /steamcmd-cache/steamcmd_linux.tar.gz ]; then \
      wget -O /steamcmd-cache/steamcmd_linux.tar.gz \
        https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz; \
    fi && \
    mkdir -p "${STEAMCMD_DIR}" && \
    cp /steamcmd-cache/steamcmd_linux.tar.gz /tmp/ && \
    cd "${STEAMCMD_DIR}" && \
    tar -xzf /tmp/steamcmd_linux.tar.gz && \
    chmod +x steamcmd.sh && \
    rm -rf /tmp/steamcmd_linux.tar.gz

#
# 登录 Steam 并下载 L4D2 服务器文件
# 1) 如果有 SECRET (Docker build secrets) 则优先读取
# 2) 否则使用 fallback 中的 ARG 值；若都没有则匿名登录
#
RUN --mount=type=secret,id=STEAM_USERNAME \
    --mount=type=secret,id=STEAM_PASSWORD \
    --mount=type=cache,target=${SERVER_DIR},uid=1000,gid=1000 \
    STEAM_USERNAME="$( [ -f /run/secrets/STEAM_USERNAME ] && cat /run/secrets/STEAM_USERNAME || cat "${HOME_DIR}/steam_username_fallback" )" && \
    STEAM_PASSWORD="$( [ -f /run/secrets/STEAM_PASSWORD ] && cat /run/secrets/STEAM_PASSWORD || cat "${HOME_DIR}/steam_password_fallback" )" && \
    if [ -n "$STEAM_USERNAME" ] && [ -n "$STEAM_PASSWORD" ]; then \
      echo "Using provided Steam credentials"; \
      LOGIN_ARGS="login $STEAM_USERNAME $STEAM_PASSWORD"; \
    else \
      echo "Using anonymous login"; \
      LOGIN_ARGS="login anonymous"; \
    fi && \
    # 注意平台变量 PLATFORM 需提前定义或在 build 时设置
    bash "${STEAMCMD_DIR}/steamcmd.sh" \
      +force_install_dir "${SERVER_DIR}" \
      +${LOGIN_ARGS} \
      +@sSteamCmdForcePlatformType windows \
      +app_update 222860 validate \
      +quit || exit 1 && \
    bash "${STEAMCMD_DIR}/steamcmd.sh" \
      +force_install_dir "${SERVER_DIR}" \
      +${LOGIN_ARGS} \
      +@sSteamCmdForcePlatformType linux \
      +app_update 222860 validate \
      +quit || exit 1 && \
    # 移除不再需要的明文凭证
    rm -f "${HOME_DIR}/steam_username_fallback" "${HOME_DIR}/steam_password_fallback" && \
    # 删除不需要的默认 motd/host 文件
    rm -f "${GAME_DIR}/host.txt" "${GAME_DIR}/motd.txt"

# ========= Stage 2: Final 运行镜像 =========
FROM debian:12-slim
LABEL org.opencontainers.image.source="https://github.com/HoshinoRei/l4d2server-docker"
LABEL L4D2_VERSION=2243

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# 同样明确指定路径
ENV STEAM_USER=steam
ENV HOME_DIR=/home/steam
ENV SERVER_DIR=/home/steam/l4d2server
ENV GAME_DIR=/home/steam/l4d2server/left4dead2

# 安装运行时依赖，创建运行用户
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        lib32gcc-s1 \
        bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    adduser --home "${HOME_DIR}" --disabled-password --shell /bin/bash --gecos "user for running steam" --quiet "${STEAM_USER}"

USER "${STEAM_USER}"
WORKDIR "${HOME_DIR}"

# 从 builder 阶段复制已下载的服务器文件
COPY --from=builder "${SERVER_DIR}" "${SERVER_DIR}"

# 服务器常用端口
EXPOSE 27015 27015/udp

# 定义数据卷：包括常见的插件、配置、motd/host 等
VOLUME ["${GAME_DIR}/addons", "${GAME_DIR}/cfg/server.cfg", "${GAME_DIR}/motd.txt", "${GAME_DIR}/host.txt", "/plugins"]

# 拷贝入口脚本（修改 entrypoint 不会触发重新下载游戏）
COPY --chmod='+x' entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-secure", "+exec", "server.cfg", "+map", "c1m1_hotel", "-port", "27015"]
