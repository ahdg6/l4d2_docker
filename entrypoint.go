package main

import (
    "fmt"
    "log"
    "os"
    "os/exec"
    "path/filepath"
    "strings"
)

// 是否开启调试模式，可通过环境变量 DEBUG=1 控制
var debugMode bool

// 记录所有新建的软链接，用于最终只列出这些文件
var mappedSymlinks []string

func debugLog(format string, v ...interface{}) {
    if debugMode {
        log.Printf(format, v...)
    }
}

// dirExists 判断给定路径是否存在且为目录
func dirExists(path string) bool {
    info, err := os.Stat(path)
    if err != nil {
        return false
    }
    return info.IsDir()
}

// fileOrSymlinkExists 判断给定路径是否存在（文件/软链接均可）
func fileOrSymlinkExists(path string) bool {
    if _, err := os.Lstat(path); err == nil {
        return true
    }
    return false
}

// cleanupOldSymlinks 函数：在游戏目录 (GAME_DIR) 下，
// 删除 addons、cfg 目录中指向 /plugins 的旧软链接，以便“回收”已失效的链接。
func cleanupOldSymlinks(gameDir string) {
    // 我们只需要清理 addons 和 cfg 下的内容
    subDirs := []string{"addons", "cfg"}

    for _, sub := range subDirs {
        targetDir := filepath.Join(gameDir, sub)
        if !dirExists(targetDir) {
            continue
        }
        // 递归遍历目录
        filepath.WalkDir(targetDir, func(path string, d os.DirEntry, err error) error {
            if err != nil {
                // 如果遍历时出错，记录一下然后继续
                debugLog("清理时读取目录出错: %v", err)
                return nil
            }
            // 如果是软链接，则检查它指向的路径
            if d.Type()&os.ModeSymlink != 0 {
                linkTarget, readErr := os.Readlink(path)
                if readErr == nil {
                    // 简单判断：如果目标路径包含 "/plugins"，则删除
                    // （也可以根据需要再做更精确的路径检查）
                    if strings.Contains(linkTarget, "/plugins") {
                        debugLog("删除旧软链接: [%s] -> [%s]", path, linkTarget)
                        if err := os.Remove(path); err != nil {
                            log.Printf("删除软链接失败: %v", err)
                        }
                    }
                }
            }
            return nil
        })
    }
}

// symlinkRecursive 递归扫描 srcDir，将文件与目录软链接到 dstDir。
// 同时将每个新创建的链接记录到 mappedSymlinks 中。
func symlinkRecursive(srcDir, dstDir string) error {
    debugLog("映射目录: [%s] -> [%s]", srcDir, dstDir)

    // 确保目标目录存在
    if err := os.MkdirAll(dstDir, 0755); err != nil {
        return fmt.Errorf("创建目录失败: %w", err)
    }

    entries, err := os.ReadDir(srcDir)
    if err != nil {
        return fmt.Errorf("读取目录失败 %s: %w", srcDir, err)
    }

    for _, entry := range entries {
        srcPath := filepath.Join(srcDir, entry.Name())
        dstPath := filepath.Join(dstDir, entry.Name())

        info, err := entry.Info()
        if err != nil {
            debugLog("无法获取文件信息: %s, err=%v", srcPath, err)
            continue
        }

        if info.IsDir() {
            // 递归处理子目录
            if err := symlinkRecursive(srcPath, dstPath); err != nil {
                return err
            }
        } else {
            // 先删除目标文件/软链接，以确保能创建新的软链接
            if fileOrSymlinkExists(dstPath) {
                if removeErr := os.Remove(dstPath); removeErr != nil {
                    return fmt.Errorf("删除旧的软链接/文件失败: %w", removeErr)
                }
            }
            debugLog("创建软链接: [%s] -> [%s]", srcPath, dstPath)
            if err := os.Symlink(srcPath, dstPath); err != nil {
                return fmt.Errorf("创建软链接失败: %w", err)
            }
            // 记录本次新建的链接
            mappedSymlinks = append(mappedSymlinks, dstPath)
        }
    }
    return nil
}

// processPluginDir 处理单个插件目录：
// 1) 若包含 left4dead2 子目录则用它为基础
// 2) 对基础目录下的 addons/cfg 进行递归软链接
// 返回 bool 表示是否实际创建了软链接。
func processPluginDir(pluginDir, gameDir string) bool {
    baseDir := pluginDir
    if dirExists(filepath.Join(pluginDir, "left4dead2")) {
        baseDir = filepath.Join(pluginDir, "left4dead2")
        debugLog("插件 [%s] 包含 left4dead2 子目录，使用 [%s] 作为基础目录。", pluginDir, baseDir)
    }

    pluginAdded := false
    for _, sub := range []string{"addons", "cfg"} {
        subPath := filepath.Join(baseDir, sub)
        if dirExists(subPath) {
            debugLog("为插件 [%s] 中的 %s 创建软链接（递归映射目录）...", pluginDir, sub)
            dstPath := filepath.Join(gameDir, sub)
            if err := symlinkRecursive(subPath, dstPath); err != nil {
                log.Printf("ERROR: 映射 %s -> %s 失败: %v", subPath, dstPath, err)
                continue
            }
            pluginAdded = true
        } else {
            debugLog("插件 [%s] 中无 %s 目录。", pluginDir, sub)
        }
    }
    return pluginAdded
}

func main() {
    // 检查环境变量 DEBUG 是否为 "1" 来决定是否打印调试信息
    debugMode = (os.Getenv("DEBUG") == "1")
    log.Println("启动 Go 版 entrypoint 脚本...")

    // 从环境变量获取游戏目录和服务器目录
    GAME_DIR := os.Getenv("GAME_DIR")
    if GAME_DIR == "" {
        GAME_DIR = "/home/steam/l4d2server/left4dead2"
    }
    SERVER_DIR := os.Getenv("SERVER_DIR")
    if SERVER_DIR == "" {
        SERVER_DIR = "/home/steam/l4d2server"
    }

    // 这里先进行一次“软链接回收”：删除上一轮残留的旧软链接（指向 /plugins 的）
    cleanupOldSymlinks(GAME_DIR)

    // 准备统计信息
    pluginsDir := "/plugins"
    pluginsAddedCount := 0
    var pluginsNotAdded []string

    // 如果有 /plugins 目录，则遍历插件
    if dirExists(pluginsDir) {
        log.Println("检测到 /plugins 目录，开始创建插件软链接...")
        entries, err := os.ReadDir(pluginsDir)
        if err != nil {
            log.Fatalf("读取 /plugins 目录失败: %v", err)
        }
        for _, e := range entries {
            item := filepath.Join(pluginsDir, e.Name())
            if !e.IsDir() {
                continue // 跳过非目录
            }
            // 判断是否直接包含可识别子目录，如果有则直接处理
            if dirExists(filepath.Join(item, "left4dead2")) ||
                dirExists(filepath.Join(item, "addons")) ||
                dirExists(filepath.Join(item, "cfg")) {
                added := processPluginDir(item, GAME_DIR)
                if added {
                    pluginsAddedCount++
                } else {
                    pluginsNotAdded = append(pluginsNotAdded, item)
                }
            } else {
                // 否则认为它是“管理文件夹”，遍历其下一级目录
                debugLog("DEBUG: [%s] 不直接包含插件内容，检查其子目录...", item)
                subEntries, err := os.ReadDir(item)
                if err != nil {
                    log.Printf("读取子目录失败: %s, err=%v", item, err)
                    continue
                }
                for _, se := range subEntries {
                    pluginPath := filepath.Join(item, se.Name())
                    if se.IsDir() {
                        added := processPluginDir(pluginPath, GAME_DIR)
                        if added {
                            pluginsAddedCount++
                        } else {
                            pluginsNotAdded = append(pluginsNotAdded, pluginPath)
                        }
                    }
                }
            }
        }
    } else {
        log.Println("未检测到 /plugins 目录，跳过插件处理。")
    }

    // 输出统计信息
    fmt.Println("====================================")
    fmt.Printf("已添加插件数量: %d\n", pluginsAddedCount)
    if len(pluginsNotAdded) > 0 {
        fmt.Println("未添加插件列表:")
        for _, p := range pluginsNotAdded {
            fmt.Printf(" - %s\n", p)
        }
    } else {
        fmt.Println("所有插件均已添加软链接。")
    }
    fmt.Println("====================================")

    // 只打印本次真正新建的软链接文件
    fmt.Println("以下文件已映射(软链接创建)：")
    if len(mappedSymlinks) == 0 {
        fmt.Println(" (没有任何新建软链接)")
    } else {
        for _, path := range mappedSymlinks {
            fmt.Println(" -", path)
        }
    }

    log.Println("启动 Left 4 Dead 2 服务器...")

    // 拼出要执行的命令： srcds_run -game left4dead2 + 其余参数
    args := []string{
        filepath.Join(SERVER_DIR, "srcds_run"),
        "-game", "left4dead2",
    }
    // 追加运行时给定的参数
    if len(os.Args) > 1 {
        args = append(args, os.Args[1:]...)
    }

    // 启动服务器时，把容器的标准输入/输出/错误直接连接过去，
    // 这样 docker attach 就能与服务器控制台交互
    cmd := exec.Command(args[0], args[1:]...)
    cmd.Stdin = os.Stdin // 关键：使服务器进程能从当前容器的 stdin 读输入
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr

    // 运行
    if err := cmd.Run(); err != nil {
        // 如果服务器进程退出码非0，err 会是 *exec.ExitError
        log.Printf("服务器进程结束，错误: %v", err)
        if exitError, ok := err.(*exec.ExitError); ok {
            os.Exit(exitError.ExitCode())
        } else {
            os.Exit(1)
        }
    }
    log.Println("服务器进程正常退出。")
}
