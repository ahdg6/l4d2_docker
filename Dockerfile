# syntax=docker/dockerfile:1.2

###########################################################################
# =============== 1) base 阶段：公用的依赖 + 用户创建 ======================
###########################################################################
FROM debian:12-slim AS base

LABEL org.opencontainers.image.source="https://github.com/ahdg6/l4d2server-docker"
LABEL L4D2_VERSION=2243

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# 安装各阶段都需要的依赖 (bash、lib32gcc-s1 等等)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        lib32gcc-s1 \
        lib32stdc++6 \
        wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 创建 steam 用户和家目录
RUN adduser --home /home/steam --disabled-password --shell /bin/bash \
    --gecos "user for running steam" --quiet steam

# 用 root 权限先建一个缓存目录（并授权给 steam）
RUN mkdir -p /steamcmd-cache && chown steam:steam /steamcmd-cache

# 确保最后阶段依旧是 root 用户（方便在下一个 stage COPY 时处理权限）
USER root


###########################################################################
# =============== 2) builder 阶段：下载 & 安装 L4D2 服务器 ==================
###########################################################################
FROM base AS builder

# 同样的环境变量（方便引用）
ENV STEAM_USER=steam
ENV HOME_DIR=/home/steam
ENV SERVER_DIR=/home/steam/l4d2server
ENV GAME_DIR=/home/steam/l4d2server/left4dead2
ENV STEAMCMD_DIR=/home/steam/steamcmd

# 可选：从外部传入 Steam 凭证（若需要非匿名登录）
ARG STEAM_USERNAME_ARG=""
ARG STEAM_PASSWORD_ARG=""

# 切回 steam 用户来执行实际下载
USER steam
WORKDIR "${HOME_DIR}"
RUN echo "${STEAM_USERNAME_ARG}" > "${HOME_DIR}/steam_username_fallback" && \
    echo "${STEAM_PASSWORD_ARG}" > "${HOME_DIR}/steam_password_fallback"

# 缓存 steamcmd 并解压
#
# 2) 下载 SteamCMD 压缩包并解压
#    使用 BuildKit cache 避免重复下载
#
RUN --mount=type=cache,target=/steamcmd-cache,uid=1000,gid=1000 \
    if [ ! -f /steamcmd-cache/steamcmd_linux.tar.gz ]; then \
      echo "[*] 未发现 steamcmd_linux.tar.gz，开始下载..."; \
      wget -O /steamcmd-cache/steamcmd_linux.tar.gz \
        https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz; \
    else \
      echo "[*] 发现已有缓存 /steamcmd-cache/steamcmd_linux.tar.gz，直接复用..."; \
    fi && \
    mkdir -p "${STEAMCMD_DIR}" && \
    cp /steamcmd-cache/steamcmd_linux.tar.gz /tmp/steamcmd_linux.tar.gz && \
    tar -xzf /tmp/steamcmd_linux.tar.gz -C "${STEAMCMD_DIR}" && \
    rm -f /tmp/steamcmd_linux.tar.gz && \
    chmod +x "${STEAMCMD_DIR}/steamcmd.sh"

#
# 3) 用 SteamCMD 下载 L4D2 Dedicated Server
#    - 必须先下载 Windows 版，再下载 Linux 版 (V 社某些 BUG 的 workaround)
#    - 同样配合 BuildKit cache 避免重复拉取
#
RUN --mount=type=secret,id=STEAM_USERNAME \
    --mount=type=secret,id=STEAM_PASSWORD \
    --mount=type=cache,target=${SERVER_DIR},uid=1000,gid=1000 \
    STEAM_USERNAME="$( [ -f /run/secrets/STEAM_USERNAME ] && cat /run/secrets/STEAM_USERNAME || cat "${HOME_DIR}/steam_username_fallback" )" && \
    STEAM_PASSWORD="$( [ -f /run/secrets/STEAM_PASSWORD ] && cat /run/secrets/STEAM_PASSWORD || cat "${HOME_DIR}/steam_password_fallback" )" && \
    if [ -n "$STEAM_USERNAME" ] && [ -n "$STEAM_PASSWORD" ]; then \
      echo "Using provided Steam credentials: $STEAM_USERNAME"; \
      LOGIN_ARGS="login $STEAM_USERNAME $STEAM_PASSWORD"; \
    else \
      echo "Using anonymous login"; \
      LOGIN_ARGS="login anonymous"; \
    fi && \
    echo "[*] 下载/更新 Windows 版服务器..." && \
    bash "${STEAMCMD_DIR}/steamcmd.sh" \
         +force_install_dir "${SERVER_DIR}" \
         +${LOGIN_ARGS} \
         +@sSteamCmdForcePlatformType windows \
         +app_update 222860 validate \
         +quit || exit 1 && \
    echo "[*] 下载/更新 Linux 版服务器..." && \
    bash "${STEAMCMD_DIR}/steamcmd.sh" \
         +force_install_dir "${SERVER_DIR}" \
         +${LOGIN_ARGS} \
         +@sSteamCmdForcePlatformType linux \
         +app_update 222860 validate \
         +quit || exit 1 && \
    rm -f steam_username_fallback steam_password_fallback && \
    # 删掉不需要的 motd/host 文件
    rm -f "${GAME_DIR}/motd.txt" "${GAME_DIR}/host.txt"


###########################################################################
# =============== 3) final 阶段：拷贝产物 + 准备运行环境 ====================
###########################################################################
FROM base

# 复制一遍相同环境变量
ENV STEAM_USER=steam
ENV HOME_DIR=/home/steam
ENV SERVER_DIR=/home/steam/l4d2server
ENV GAME_DIR=/home/steam/l4d2server/left4dead2
ENV STEAMCMD_DIR=/home/steam/steamcmd

# 以 root 身份复制文件
USER root

# 1) 从 builder 拷贝 L4D2 服务器文件 + steamcmd
COPY --from=builder "${SERVER_DIR}" "${SERVER_DIR}"
COPY --from=builder "${STEAMCMD_DIR}" "${STEAMCMD_DIR}"

# 2) 统一把服务器目录的所有权改成 steam 用户，避免后续写权限问题
RUN chown -R steam:steam "${SERVER_DIR}" && \
    chown -R steam:steam "${STEAMCMD_DIR}"

# 3) 在 ~/.steam/sdk32 建立符号链接，让 SRCDS 能找到 steamclient.so
RUN mkdir -p /home/steam/.steam/sdk32 && \
    ln -s "${STEAMCMD_DIR}/linux32/steamclient.so" /home/steam/.steam/sdk32/steamclient.so && \
    chown -R steam:steam /home/steam/.steam

# 4) 如果想进一步精简镜像，又不打算在容器内更新，可以删除 steamcmd
# RUN rm -rf "${STEAMCMD_DIR}"

#
# 复制并设置 entrypoint
# 你可以自行把这个 entrypoint.sh 放在项目同目录
#
COPY entrypoint.sh /entrypoint.sh
RUN chown steam:steam /entrypoint.sh && chmod +x /entrypoint.sh

# 切回 steam 用户，设定工作目录
USER steam
WORKDIR "${HOME_DIR}"

# 暴露常见端口
EXPOSE 27015 27015/udp

# 如果想把 cfg/server.cfg、motd.txt 等做成数据卷，也可以加:
# VOLUME ["${GAME_DIR}/addons", "${GAME_DIR}/cfg/server.cfg", "${GAME_DIR}/motd.txt", "${GAME_DIR}/host.txt"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-secure", "+exec", "server.cfg", "+map", "c1m1_hotel", "-port", "27015"]
