#!/bin/bash
set -e

echo "启动 entrypoint 脚本..."

: "${GAME_DIR:=/home/steam/l4d2server/left4dead2}"
: "${SERVER_DIR:=/home/steam/l4d2server}"

# 定义处理单个插件目录的函数
process_plugin_dir() {
    local plugin_dir="$1"
    # 检查是否存在 left4dead2 子目录
    if [ -d "$plugin_dir/left4dead2" ]; then
        base_plugin_dir="$plugin_dir/left4dead2"
        echo "插件 [$plugin_dir] 包含 left4dead2 子目录，使用 [$base_plugin_dir] 作为基础目录。"
    else
        base_plugin_dir="$plugin_dir"
    fi

    # 遍历 addons 和 cfg 目录
    for sub in addons cfg; do
        if [ -d "$base_plugin_dir/$sub" ]; then
            echo "为插件 [$plugin_dir] 中的 $sub 创建软链接..."
            mkdir -p "$GAME_DIR/$sub"
            for item in "$base_plugin_dir/$sub/"*; do
                # 跳过空目录
                [ -e "$item" ] || continue
                ln -sf "$item" "$GAME_DIR/$sub/$(basename "$item")"
            done
        fi
    done
}

if [ -d /plugins ]; then
    echo "检测到 /plugins 目录，开始创建插件软链接..."
    # 遍历 /plugins 下的一级目录
    for item in /plugins/*; do
        [ -d "$item" ] || continue
        # 如果当前目录直接包含插件文件，则按插件处理
        if [ -d "$item/left4dead2" ] || [ -d "$item/addons" ] || [ -d "$item/cfg" ]; then
            process_plugin_dir "$item"
        else
            # 否则，认为当前目录为管理类文件夹，只遍历其下一级目录
            for plugin in "$item"/*; do
                [ -d "$plugin" ] || continue
                process_plugin_dir "$plugin"
            done
        fi
    done
else
    echo "未检测到 /plugins 目录，跳过插件处理。"
fi

echo "启动 Left 4 Dead 2 服务器..."
exec "${SERVER_DIR}/srcds_run" "-game left4dead2" "$@"
