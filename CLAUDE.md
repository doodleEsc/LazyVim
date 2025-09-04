# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About LazyVim

这是 LazyVim，一个基于 lazy.nvim 的 Neovim 配置框架。LazyVim 不是一个最终用户配置，而是为开发者提供的框架，用于创建和扩展 Neovim 配置。

## Development Commands

### Testing
```bash
# 运行测试套件
./scripts/test

# 或者直接使用：
nvim -l tests/minit.lua --minitest
```

### Code Quality
```bash
# 格式化 Lua 代码 (需要 stylua)
stylua .

# Lua 静态分析 (需要 selene)
selene .
```

### Documentation
```bash
# 生成文档标签
nvim --headless -c "helptags doc" -c quit
```

## Project Architecture

### Core Structure
- `lua/lazyvim/` - 核心框架代码
  - `config/` - 默认配置（autocmds, keymaps, options）
  - `plugins/` - 核心插件规范
  - `util/` - 实用工具函数

### Plugin System
LazyVim 使用分层的插件系统：
1. **Core plugins** (`lua/lazyvim/plugins/`) - 基础插件集合
2. **Extra plugins** (`lua/lazyvim/plugins/extras/`) - 可选功能模块
   - `ai/` - AI 工具集成
   - `coding/` - 编程辅助工具
   - `editor/` - 编辑器增强
   - `formatting/` - 代码格式化
   - `lang/` - 语言特定支持
   - `linting/` - 代码检查
   - `lsp/` - LSP 配置
   - `test/` - 测试工具
   - `ui/` - 界面主题和组件
   - `util/` - 实用工具

### Configuration Loading
LazyVim 使用自动加载机制：
- 配置文件按照特定顺序自动加载
- 用户配置会覆盖默认配置
- Extra 插件通过 `LazyVim.extras` API 动态启用

### Utility Functions
`lua/lazyvim/util/` 包含核心工具模块：
- `init.lua` - 主要工具函数集合
- `lsp.lua` - LSP 相关工具
- `extras.lua` - Extra 插件管理
- `format.lua` - 格式化工具
- `root.lua` - 项目根目录检测
- 其他特定功能模块

## Code Style Guidelines

### Lua Formatting
- 使用 2 个空格缩进
- 最大行宽 120 字符
- 启用 require 语句排序
- 配置见 `stylua.toml`

### Plugin Specifications
- 遵循 lazy.nvim 的插件规范格式
- 使用适当的懒加载策略
- 确保配置可被用户覆盖
- Optional 插件需标记为 `optional = true`

### Extra Plugin Requirements
- 必须包含 `recommended` 部分
- 实现适当的懒加载
- 只在插件已安装时启用
- Lua 依赖应作为单独规范添加（`lazy=true`）

## Working with Extras

当添加或修改 extra 插件时：
1. 每个 extra 都是独立的 Lua 模块
2. 按类别组织在不同子目录中
3. 包含完整的插件配置和依赖关系
4. 遵循社区最佳实践

## Testing Guidelines

- 测试文件位于 `tests/` 目录
- 使用 `tests/minit.lua` 作为测试入口点
- 测试运行器：`./scripts/test`
- 确保所有新功能都有相应测试

## Important Notes

- 这个仓库不应被直接使用 - 用户应使用 LazyVim starter 模板
- `init.lua` 包含警告信息防止直接使用
- 所有配置都应该是可覆盖的
- 避免使用 Vim 插件，优先使用 Lua 插件