# Mac Cleanup 优化版 v2.0.0

一个功能强大、安全可靠的 macOS 系统清理工具，基于原版 mac-cleanup-sh 进行了全面优化。

## ✨ 主要特性

### 🔒 安全性增强
- **白名单保护** - 防止误删重要文件
- **备份功能** - 可选择在删除前创建备份
- **权限检查** - 避免以 root 身份运行
- **多重验证** - 删除前的安全确认

### ⚡ 性能优化
- **并行处理** - 支持多任务同时执行
- **智能缓存** - 避免重复计算
- **进度显示** - 实时显示清理进度
- **错误重试** - 自动重试失败的操作

### 🛠 功能完善
- **预览模式** - 清理前查看将被删除的内容
- **详细日志** - 完整的操作记录
- **配置管理** - 灵活的配置选项
- **清理报告** - 详细的清理统计

### 🎯 清理范围
- **系统缓存** - 系统级缓存文件
- **应用缓存** - 各类应用程序缓存
- **开发工具** - Xcode、npm、yarn、Docker 等
- **浏览器数据** - Chrome、Safari、Firefox 缓存
- **日志文件** - 系统和应用日志
- **临时文件** - 各种临时和垃圾文件

## 📦 安装

### 方法一：直接下载
```bash
# 下载脚本
curl -O https://raw.githubusercontent.com/your-repo/mac-cleanup-optimized/main/mac-cleanup-optimized

# 添加执行权限
chmod +x mac-cleanup-optimized

# 安装到系统路径
sudo mv mac-cleanup-optimized /usr/local/bin/

# 创建别名
echo "alias clean='/usr/local/bin/mac-cleanup-optimized'" >> ~/.zshrc
source ~/.zshrc
```

### 方法二：使用安装脚本
```bash
# 下载并运行安装脚本
curl -fsSL https://raw.githubusercontent.com/your-repo/mac-cleanup-optimized/main/install.sh | bash
```

## 🚀 使用方法

### 基本用法
```bash
# 预览清理效果（推荐首次使用）
clean -d

# 执行清理
clean

# 详细模式
clean -v

# 创建备份并清理
clean -b

# 更新 Homebrew 并清理
clean -u
```

### 高级选项
```bash
# 完整参数列表
clean -h

# 并行处理（默认启用）
clean -p

# 静默模式
clean -q

# 自定义配置文件
clean -c /path/to/config.conf

# 重置配置
clean --reset-config
```

## ⚙️ 配置

### 配置文件位置
- **主配置**: `~/.mac-cleanup/config.conf`
- **白名单**: `~/.mac-cleanup/whitelist.txt`
- **日志目录**: `~/.mac-cleanup/`

### 配置选项说明
```bash
# 基本选项
dry_run=false              # 预览模式
verbose=false              # 详细输出
update_brew=false          # 更新 Homebrew
backup=false               # 创建备份
parallel=true              # 并行处理
show_progress=true         # 显示进度
auto_confirm=false         # 自动确认
max_parallel_jobs=4        # 最大并行任务数
```

### 白名单配置
在 `~/.mac-cleanup/whitelist.txt` 中添加不希望被清理的路径：

```
# 重要应用缓存
/Users/username/Library/Caches/com.important.app

# 开发项目缓存
/Users/username/Projects/important-project/node_modules/.cache

# 特定目录
/Applications/CriticalApp.app/Contents/cache
```

## 📊 清理报告

每次清理后会生成详细报告，包含：
- 释放的磁盘空间
- 处理的文件数量
- 遇到的错误统计
- 清理耗时
- 详细的操作日志

示例报告：
```
======================================
Mac Cleanup 清理报告
======================================
时间: 2024-01-15 14:30:25
版本: 2.0.0

清理统计:
  释放空间: 2.3GB
  处理文件: 1,247
  错误数量: 0

清理模式: 实际清理
并行处理: true
创建备份: false

详细日志: ~/.mac-cleanup/cleanup-20240115_143025.log
======================================
```

## 🔧 故障排除

### 常见问题

**Q: 权限被拒绝**
```bash
# 确保有正确的权限
sudo chown $(whoami) /usr/local/bin/mac-cleanup-optimized
chmod +x /usr/local/bin/mac-cleanup-optimized
```

**Q: 某些文件无法删除**
```bash
# 检查文件是否被其他程序占用
lsof /path/to/file

# 或添加到白名单
echo "/path/to/file" >> ~/.mac-cleanup/whitelist.txt
```

**Q: 清理后某个应用无法正常工作**
```bash
# 从备份恢复（如果启用了备份）
ls ~/.mac-cleanup/backup-*

# 或重新安装该应用
```

### 日志分析
```bash
# 查看最新的清理日志
ls -t ~/.mac-cleanup/cleanup-*.log | head -1 | xargs cat

# 搜索错误信息
grep "ERROR" ~/.mac-cleanup/cleanup-*.log
```

## 🚫 卸载

```bash
# 运行卸载脚本
~/.mac-cleanup/uninstall.sh

# 或手动删除
sudo rm /usr/local/bin/mac-cleanup-optimized
rm -rf ~/.mac-cleanup

# 删除别名（从 ~/.zshrc 或 ~/.bashrc 中移除）
# alias clean='/usr/local/bin/mac-cleanup-optimized'
```

## ⚠️ 注意事项

### 安全建议
1. **首次使用前务必运行预览模式** (`clean -d`)
2. **重要数据请定期备份**
3. **检查白名单设置**，避免误删重要缓存
4. **谨慎使用备份功能**，可能占用大量磁盘空间

### 兼容性
- **系统要求**: macOS 10.0 或更高版本
- **依赖工具**: bash 4.0+, 基本的 Unix 工具
- **推荐安装**: `bc` 命令（用于更好的数字格式化）

### 性能建议
- 在 SSD 上运行效果更佳
- 并行处理可能增加 CPU 使用率
- 大型清理操作建议在空闲时间进行

## 📝 更新日志

### v2.0.0
- 🎉 完全重写，大幅提升安全性和性能
- ➕ 新增白名单保护机制
- ➕ 新增备份功能
- ➕ 新增并行处理支持
- ➕ 新增详细的日志和报告
- ➕ 新增配置文件管理
- 🔧 改进错误处理和重试机制
- 🔧 优化用户界面和进度显示

### v1.x.x
- 基于原版 mac-cleanup-sh 的改进

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发环境设置
```bash
# 克隆仓库
git clone https://github.com/your-repo/mac-cleanup-optimized.git
cd mac-cleanup-optimized

# 运行测试
./test.sh

# 格式化代码
shellcheck mac-cleanup-optimized
```

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

感谢原始项目 [mac-cleanup-sh](https://github.com/mac-cleanup/mac-cleanup-sh) 的作者和贡献者们。

---

**⭐ 如果这个工具对你有帮助，请给个 Star！**