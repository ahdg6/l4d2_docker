#!/bin/bash
set -e

echo "启动 entrypoint 脚本..."

: "${GAME_DIR:=/home/steam/l4d2server/left4dead2}"
: "${SERVER_DIR:=/home/steam/l4d2server}"

if [ -d /plugins ]; then
    echo "检测到 /plugins 目录，开始创建插件软链接..."
    for plugin in /plugins/*; do
        if [ -d "$plugin" ]; then
            for sub in addons cfg; do
                if [ -d "$plugin/$sub" ]; then
                    echo "为插件 [$plugin] 中的 $sub 创建软链接..."
                    # 确保目标目录存在
                    mkdir -p "$GAME_DIR/$sub"
                    for item in "$plugin/$sub/"*; do
                        ln -sf "$item" "$GAME_DIR/$sub/$(basename "$item")"
                    done
                fi
            done
        fi
    done
else
    echo "未检测到 /plugins 目录，跳过插件处理。"
fi

echo "启动 Left 4 Dead 2 服务器..."
exec "${SERVER_DIR}/srcds_run" "-game left4dead2" "$@"
