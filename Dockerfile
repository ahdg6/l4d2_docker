# Stage 1: 构建更新版服务器（builder 阶段）
FROM debian:12-slim AS builder
LABEL org.opencontainers.image.source="https://github.com/ahdg6/l4d2_docker"
LABEL L4D2_VERSION=2243

# 设置基础语言环境变量
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# 定义用户及目录相关环境变量
ENV STEAM_USER=steam \
    HOME_DIR=/home/${STEAM_USER} \
    SERVER_DIR=${HOME_DIR}/l4d2server \
    GAME_DIR=${SERVER_DIR}/left4dead2

# 定义构建参数（可通过 --build-arg 传入）
ARG STEAM_USERNAME_ARG=""
ARG STEAM_PASSWORD_ARG=""

# 安装依赖、创建用户并清理缓存
RUN apt-get update && \
    apt-get install -y wget lib32gcc-s1 ca-certificates && \
    adduser --home ${HOME_DIR} --disabled-password --shell /bin/bash --gecos "user for running steam" --quiet ${STEAM_USER} && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 以 root 用户创建缓存目录并赋予 steam 用户权限
USER root
RUN mkdir -p /steamcmd-cache && chown ${STEAM_USER}:${STEAM_USER} /steamcmd-cache

# 在 root 下生成 fallback 文件到 HOME_DIR，并设置正确权限
RUN echo "$STEAM_USERNAME_ARG" > ${HOME_DIR}/steam_username_fallback && \
    echo "$STEAM_PASSWORD_ARG" > ${HOME_DIR}/steam_password_fallback && \
    chown ${STEAM_USER}:${STEAM_USER} ${HOME_DIR}/steam_username_fallback ${HOME_DIR}/steam_password_fallback

# 切换回 steam 用户并设置工作目录
USER ${STEAM_USER}
WORKDIR ${HOME_DIR}

# 利用 BuildKit cache 挂载下载 steamcmd（仅在缓存不存在时下载）
RUN --mount=type=cache,target=/steamcmd-cache \
    if [ ! -f /steamcmd-cache/steamcmd_linux.tar.gz ]; then \
      wget -O /steamcmd-cache/steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz; \
    fi && \
    cp /steamcmd-cache/steamcmd_linux.tar.gz . && \
    tar -xzf steamcmd_linux.tar.gz && \
    rm -rf steamcmd_linux.tar.gz

# 使用 steamcmd 更新 Left 4 Dead 2 服务器
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
        ./steamcmd.sh +force_install_dir ${SERVER_DIR} +login $STEAM_USERNAME $STEAM_PASSWORD +@sSteamCmdForcePlatformType windows +app_update 222860 validate +quit && \
        ./steamcmd.sh +force_install_dir ${SERVER_DIR} +login $STEAM_USERNAME $STEAM_PASSWORD +@sSteamCmdForcePlatformType linux +app_update 222860 validate +quit; \
    else \
        echo "Using anonymous login"; \
        ./steamcmd.sh +force_install_dir ${SERVER_DIR} +login anonymous +@sSteamCmdForcePlatformType windows +app_update 222860 validate +quit && \
        ./steamcmd.sh +force_install_dir ${SERVER_DIR} +login anonymous +@sSteamCmdForcePlatformType linux +app_update 222860 validate +quit; \
    fi && \
    rm -rf ${GAME_DIR}/host.txt ${GAME_DIR}/motd.txt

# Stage 2: 最终镜像
FROM debian:12-slim
LABEL org.opencontainers.image.source="https://github.com/HoshinoRei/l4d2server-docker"
LABEL L4D2_VERSION=2243

# 设置基础语言环境变量
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# 定义用户及目录相关环境变量
ENV STEAM_USER=steam \
    HOME_DIR=/home/${STEAM_USER} \
    SERVER_DIR=${HOME_DIR}/l4d2server \
    GAME_DIR=${SERVER_DIR}/left4dead2

# 安装运行时依赖、创建用户并清理缓存
RUN apt-get update && apt-get install -y lib32gcc-s1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    adduser --home ${HOME_DIR} --disabled-password --shell /bin/bash --gecos "user for running steam" --quiet ${STEAM_USER}

USER ${STEAM_USER}
WORKDIR ${HOME_DIR}

# 从 builder 阶段复制已更新的服务器文件
COPY --from=builder ${SERVER_DIR} ${SERVER_DIR}

# 开放必要端口
EXPOSE 27015 27015/udp

# 定义持久化数据卷，同时挂载 /plugins 目录用于外部传入插件、地图等数据
VOLUME ["${GAME_DIR}/addons", "${GAME_DIR}/cfg/server.cfg", "${GAME_DIR}/motd.txt", "${GAME_DIR}/host.txt", "/plugins"]

# 拷贝入口脚本并赋予执行权限（利用 BuildKit 的 --chmod 选项）
COPY --chmod=+x entrypoint.sh /entrypoint.sh

# 设置入口脚本和默认启动参数
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-secure", "+exec", "server.cfg", "+map", "c1m1_hotel", "-port", "27015"]
