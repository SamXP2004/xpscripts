#!/usr/bin/env bash

# Mac Cleanup 优化版安装脚本

set -euo pipefail

readonly SCRIPT_NAME="mac-cleanup-optimized"
readonly INSTALL_DIR="/usr/local/bin"
readonly CONFIG_DIR="$HOME/.mac-cleanup"
readonly GITHUB_URL="https://raw.githubusercontent.com/your-repo/mac-cleanup-optimized/main"

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

# 日志函数
log() {
    local level="$1"
    shift
    local message="$*"
    
    case "$level" in
        ERROR)
            echo -e "${RED}❌ $message${RESET}" >&2
            ;;
        WARN)
            echo -e "${YELLOW}⚠️  $message${RESET}" >&2
            ;;
        INFO)
            echo -e "${BLUE}ℹ️  $message${RESET}"
            ;;
        SUCCESS)
            echo -e "${GREEN}✅ $message${RESET}"
            ;;
        *)
            echo "$message"
            ;;
    esac
}

# 错误处理
die() {
    log ERROR "$1"
    exit "${2:-1}"
}

# 检查系统要求
check_requirements() {
    if [[ "$(uname)" != "Darwin" ]]; then
        die "此脚本仅支持 macOS 系统"
    fi
    
    if ! command -v curl >/dev/null 2>&1; then
        die "需要 curl 命令"
    fi
    
    if ! command -v bc >/dev/null 2>&1; then
        log WARN "建议安装 bc 命令以获得更好的体验: brew install bc"
    fi
}

# 创建配置目录
create_config_dir() {
    if [[ ! -d "$CONFIG_DIR" ]]; then
        mkdir -p "$CONFIG_DIR"
        log SUCCESS "创建配置目录: $CONFIG_DIR"
    fi
}

# 创建默认配置文件
create_default_config() {
    local config_file="$CONFIG_DIR/config.conf"
    
    if [[ ! -f "$config_file" ]]; then
        cat > "$config_file" <<EOF
# Mac Cleanup 优化版配置文件
# 生成时间: $(date)

# 基本选项
dry_run=false
verbose=false
update_brew=false
backup=false
parallel=true
show_progress=true
auto_confirm=false
max_parallel_jobs=4
EOF
        log SUCCESS "创建默认配置文件: $config_file"
    fi
}

# 创建默认白名单文件
create_default_whitelist() {
    local whitelist_file="$CONFIG_DIR/whitelist.txt"
    
    if [[ ! -f "$whitelist_file" ]]; then
        cat > "$whitelist_file" <<EOF
# Mac Cleanup 白名单文件
# 在此文件中列出不希望被清理的路径
# 每行一个路径，支持通配符

# 示例：
# /Users/username/Documents/important_cache
# /Applications/MyApp.app/Contents/cache
# ~/Library/Caches/com.important.app

EOF
        log SUCCESS "创建默认白名单文件: $whitelist_file"
    fi
}

# 安装脚本
install_script() {
    local script_path="$INSTALL_DIR/$SCRIPT_NAME"
    
    log INFO "正在安装 $SCRIPT_NAME 到 $INSTALL_DIR"
    
    # 检查是否有写入权限
    if [[ ! -w "$INSTALL_DIR" ]]; then
        log INFO "需要管理员权限安装到 $INSTALL_DIR"
        sudo cp "$0" "$script_path"
        sudo chmod +x "$script_path"
    else
        cp "$0" "$script_path"
        chmod +x "$script_path"
    fi
    
    log SUCCESS "已安装到: $script_path"
}

# 设置别名
setup_alias() {
    local shell_config=""
    local alias_line="alias clean='$INSTALL_DIR/$SCRIPT_NAME'"
    
    # 检测用户的 shell
    case "$SHELL" in
        */zsh)
            shell_config="$HOME/.zshrc"
            ;;
        */bash)
            shell_config="$HOME/.bashrc"
            if [[ ! -f "$shell_config" ]]; then
                shell_config="$HOME/.bash_profile"
            fi
            ;;
        */fish)
            shell_config="$HOME/.config/fish/config.fish"
            alias_line="alias clean '$INSTALL_DIR/$SCRIPT_NAME'"
            ;;
        *)
            log WARN "未识别的 shell: $SHELL"
            return 1
            ;;
    esac
    
    if [[ -n "$shell_config" ]]; then
        if ! grep -q "alias clean=" "$shell_config" 2>/dev/null; then
            echo "" >> "$shell_config"
            echo "# Mac Cleanup 别名" >> "$shell_config"
            echo "$alias_line" >> "$shell_config"
            log SUCCESS "已添加别名到 $shell_config"
            log INFO "请运行 'source $shell_config' 或重启终端以使别名生效"
        else
            log INFO "别名已存在于 $shell_config"
        fi
    fi
}

# 创建卸载脚本
create_uninstall_script() {
    local uninstall_script="$CONFIG_DIR/uninstall.sh"
    
    cat > "$uninstall_script" <<'EOF'
#!/usr/bin/env bash

# Mac Cleanup 卸载脚本

set -euo pipefail

readonly SCRIPT_NAME="mac-cleanup-optimized"
readonly INSTALL_DIR="/usr/local/bin"
readonly CONFIG_DIR="$HOME/.mac-cleanup"

echo "正在卸载 Mac Cleanup 优化版..."

# 删除安装的脚本
if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
    if [[ -w "$INSTALL_DIR" ]]; then
        rm "$INSTALL_DIR/$SCRIPT_NAME"
    else
        sudo rm "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    echo "✅ 已删除: $INSTALL_DIR/$SCRIPT_NAME"
fi

# 询问是否删除配置文件
echo
read -p "是否删除配置文件和日志？(y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$CONFIG_DIR"
    echo "✅ 已删除配置目录: $CONFIG_DIR"
fi

# 提醒用户手动删除别名
echo
echo "⚠️  请手动从 shell 配置文件中删除以下别名："
echo "alias clean='$INSTALL_DIR/$SCRIPT_NAME'"
echo
echo "常见配置文件位置："
echo "  - ~/.zshrc (zsh)"
echo "  - ~/.bashrc 或 ~/.bash_profile (bash)"
echo "  - ~/.config/fish/config.fish (fish)"

echo
echo "✅ 卸载完成！"
EOF

    chmod +x "$uninstall_script"
    log SUCCESS "创建卸载脚本: $uninstall_script"
}

# 显示使用说明
show_usage_info() {
    echo
    echo -e "${BOLD}🎉 安装完成！${RESET}"
    echo
    echo -e "${BOLD}使用方法：${RESET}"
    echo "  clean              # 使用别名执行清理"
    echo "  $SCRIPT_NAME       # 直接执行脚本"
    echo "  $SCRIPT_NAME -h    # 查看帮助"
    echo "  $SCRIPT_NAME -d    # 预览模式"
    echo
    echo -e "${BOLD}配置文件：${RESET}"
    echo "  配置文件: $CONFIG_DIR/config.conf"
    echo "  白名单:   $CONFIG_DIR/whitelist.txt"
    echo "  日志目录: $CONFIG_DIR/"
    echo "  卸载脚本: $CONFIG_DIR/uninstall.sh"
    echo
    echo -e "${BOLD}建议操作：${RESET}"
    echo "  1. 首次使用前运行预览模式: clean -d"
    echo "  2. 根据需要编辑白名单文件"
    echo "  3. 调整配置文件中的选项"
    echo
}

# 主函数
main() {
    echo -e "${BOLD}Mac Cleanup 优化版安装程序${RESET}"
    echo
    
    check_requirements
    create_config_dir
    create_default_config
    create_default_whitelist
    
    # 如果当前脚本就是要安装的脚本
    if [[ "$(basename "$0")" == "$SCRIPT_NAME" ]]; then
        install_script
        setup_alias
        create_uninstall_script
        show_usage_info
    else
        echo "请将此安装脚本与 $SCRIPT_NAME 一起使用"
        exit 1
    fi
}

# 如果直接执行此脚本
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi