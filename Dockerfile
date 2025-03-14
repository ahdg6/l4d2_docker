# syntax=docker/dockerfile:1.2
# ========= Stage 1: Builder 阶段 =========
FROM debian:12-slim AS builder
LABEL org.opencontainers.image.source="https://github.com/HoshinoRei/l4d2server-docker"
LABEL L4D2_VERSION=2243

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# 定义用户和目录变量
ENV STEAM_USER=steam \
    HOME_DIR=/home/${STEAM_USER} \
    SERVER_DIR=${HOME_DIR}/l4d2server \
    GAME_DIR=${SERVER_DIR}/left4dead2 \
    STEAMCMD_DIR=${HOME_DIR}/steamcmd

ARG STEAM_USERNAME_ARG=""
ARG STEAM_PASSWORD_ARG=""

# 安装依赖：wget、32位库、ca-certificates 和 bash
RUN apt-get update && \
    apt-get install -y wget lib32gcc-s1 ca-certificates bash && \
    adduser --home ${HOME_DIR} --disabled-password --shell /bin/bash --gecos "user for running steam" --quiet ${STEAM_USER} && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 以 root 创建 steamcmd 缓存目录，并赋予 steam 用户权限
USER root
RUN mkdir -p /steamcmd-cache && chown ${STEAM_USER}:${STEAM_USER} /steamcmd-cache

# 在 root 下生成 fallback 文件（便于传入凭证）
RUN echo "$STEAM_USERNAME_ARG" > ${HOME_DIR}/steam_username_fallback && \
    echo "$STEAM_PASSWORD_ARG" > ${HOME_DIR}/steam_password_fallback && \
    chown ${STEAM_USER}:${STEAM_USER} ${HOME_DIR}/steam_username_fallback ${HOME_DIR}/steam_password_fallback

# 切换回 steam 用户并设置工作目录
USER ${STEAM_USER}
WORKDIR ${HOME_DIR}

# 下载并解压 SteamCMD 到专用目录 STEAMCMD_DIR
RUN --mount=type=cache,target=/steamcmd-cache,uid=1000,gid=1000 \
    if [ ! -f /steamcmd-cache/steamcmd_linux.tar.gz ]; then \
      wget -O /steamcmd-cache/steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz; \
    fi && \
    mkdir -p ${STEAMCMD_DIR} && \
    cp /steamcmd-cache/steamcmd_linux.tar.gz /tmp/ && \
    cd ${STEAMCMD_DIR} && \
    tar -xzf /tmp/steamcmd_linux.tar.gz && \
    chmod +x steamcmd.sh && \
    rm -rf /tmp/steamcmd_linux.tar.gz

# 使用 SteamCMD 更新 Left 4 Dead 2 服务器文件
RUN --mount=type=secret,id=STEAM_USERNAME \
    --mount=type=secret,id=STEAM_PASSWORD \
    if [ -f /run/secrets/STEAM_USERNAME ]; then \
      STEAM_USERNAME=$(cat /run/secrets/STEAM_USERNAME); \
    else \
      STEAM_USERNAME=$(cat ${HOME_DIR}/steam_username_fallback); \
    fi && \
    if [ -f /run/secrets/STEAM_PASSWORD ]; then \
      STEAM_PASSWORD=$(cat /run/secrets/STEAM_PASSWORD); \
    else \
      STEAM_PASSWORD=$(cat ${HOME_DIR}/steam_password_fallback); \
    fi && \
    if [ -n "$STEAM_USERNAME" ] && [ -n "$STEAM_PASSWORD" ]; then \
      echo "Using provided Steam credentials"; \
      bash ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir ${SERVER_DIR} +login $STEAM_USERNAME $STEAM_PASSWORD +@sSteamCmdForcePlatformType windows +app_update 222860 validate +quit && \
      bash ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir ${SERVER_DIR} +login $STEAM_USERNAME $STEAM_PASSWORD +@sSteamCmdForcePlatformType linux +app_update 222860 validate +quit; \
    else \
      echo "Using anonymous login"; \
      bash ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir ${SERVER_DIR} +login anonymous +@sSteamCmdForcePlatformType windows +app_update 222860 validate +quit && \
      bash ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir ${SERVER_DIR} +login anonymous +@sSteamCmdForcePlatformType linux +app_update 222860 validate +quit; \
    fi && \
    rm -rf ${GAME_DIR}/host.txt ${GAME_DIR}/motd.txt

# ========= Stage 2: 最终运行镜像 =========
FROM debian:12-slim
LABEL org.opencontainers.image.source="https://github.com/HoshinoRei/l4d2server-docker"
LABEL L4D2_VERSION=2243

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# 定义用户及目录变量
ENV STEAM_USER=steam \
    HOME_DIR=/home/${STEAM_USER} \
    SERVER_DIR=${HOME_DIR}/l4d2server \
    GAME_DIR=${SERVER_DIR}/left4dead2

# 安装运行时依赖（lib32gcc-s1 和 bash），并创建运行用户
RUN apt-get update && apt-get install -y lib32gcc-s1 bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    adduser --home ${HOME_DIR} --disabled-password --shell /bin/bash --gecos "user for running steam" --quiet ${STEAM_USER}

USER ${STEAM_USER}
WORKDIR ${HOME_DIR}

# 从 builder 阶段复制已下载的服务器文件（包含游戏文件）
COPY --from=builder ${SERVER_DIR} ${SERVER_DIR}

# 暴露必要端口
EXPOSE 27015 27015/udp

# 定义持久化数据卷，方便外部挂载插件、配置等数据
VOLUME ["${GAME_DIR}/addons", "${GAME_DIR}/cfg/server.cfg", "${GAME_DIR}/motd.txt", "${GAME_DIR}/host.txt", "/plugins"]

# 拷贝入口脚本，并设置执行权限；后续修改不会影响 builder 层缓存
COPY --chmod=+x entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-secure", "+exec", "server.cfg", "+map", "c1m1_hotel", "-port", "27015"]
