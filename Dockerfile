FROM debian:12-slim
LABEL org.opencontainers.image.source=https://github.com/HoshinoRei/l4d2server-docker
LABEL L4D2_VERSION=2243

# 设置基础语言环境变量
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV LANGUAGE=C.UTF-8

# 定义用户及目录相关环境变量
ENV STEAM_USER=steam
ENV HOME_DIR=/home/${STEAM_USER}
ENV SERVER_DIR=${HOME_DIR}/l4d2server
ENV GAME_DIR=${SERVER_DIR}/left4dead2

# 定义构建参数（本地构建时可通过 --build-arg 传入）
ARG STEAM_USERNAME_ARG=""
ARG STEAM_PASSWORD_ARG=""

# 安装依赖、创建用户并清理缓存
RUN apt-get update && \
    apt-get install -y wget lib32gcc-s1 && \
    adduser --home ${HOME_DIR} --disabled-password --shell /bin/bash --gecos "user for running steam" --quiet ${STEAM_USER} && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER ${STEAM_USER}
WORKDIR ${HOME_DIR}

# 为本地构建生成 fallback 文件（当 secrets 不存在时使用）
RUN echo "$STEAM_USERNAME_ARG" > steam_username_fallback && \
    echo "$STEAM_PASSWORD_ARG" > steam_password_fallback

# 下载 steamcmd 并更新 Left 4 Dead 2 服务器
# 如果使用 BuildKit secrets（如 GitHub Actions），则文件挂载在 /run/secrets 下；否则读取 fallback 文件
RUN --mount=type=secret,id=STEAM_USERNAME \
    --mount=type=secret,id=STEAM_PASSWORD \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xzf steamcmd_linux.tar.gz && \
    rm -rf steamcmd_linux.tar.gz && \
    \
    if [ -f /run/secrets/STEAM_USERNAME ]; then \
      STEAM_USERNAME=$(cat /run/secrets/STEAM_USERNAME); \
    else \
      STEAM_USERNAME=$(cat steam_username_fallback); \
    fi && \
    if [ -f /run/secrets/STEAM_PASSWORD ]; then \
      STEAM_PASSWORD=$(cat /run/secrets/STEAM_PASSWORD); \
    else \
      STEAM_PASSWORD=$(cat steam_password_fallback); \
    fi && \
    if [ -n "$STEAM_USERNAME" ] && [ -n "$STEAM_PASSWORD" ]; then \
      LOGIN_CMD="+login $STEAM_USERNAME $STEAM_PASSWORD"; \
      echo "Using provided Steam credentials"; \
    else \
      LOGIN_CMD="+login anonymous"; \
      echo "Using anonymous login"; \
    fi && \
    ./steamcmd.sh +force_install_dir ${SERVER_DIR} $LOGIN_CMD +@sSteamCmdForcePlatformType windows +app_update 222860 validate +quit && \
    ./steamcmd.sh +force_install_dir ${SERVER_DIR} $LOGIN_CMD +@sSteamCmdForcePlatformType linux +app_update 222860 validate +quit && \
    rm -rf ${GAME_DIR}/host.txt ${GAME_DIR}/motd.txt

# 开放必要端口
EXPOSE 27015 27015/udp

# 定义持久化数据卷，同时挂载 /plugins 目录用于外部传入插件、地图等数据
VOLUME ["${GAME_DIR}/addons", "${GAME_DIR}/cfg/server.cfg", "${GAME_DIR}/motd.txt", "${GAME_DIR}/host.txt", "/plugins"]

# 使用 BuildKit 的 --chmod 选项直接赋予执行权限
COPY --chmod=+x entrypoint.sh /entrypoint.sh

# 设置入口脚本和默认启动参数（可通过 docker-compose 的 command 覆盖）
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-secure", "+exec", "server.cfg", "+map", "c1m1_hotel", "-port", "27015"]
