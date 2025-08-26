# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是 LazyVim 项目 - 一个基于 [lazy.nvim](https://github.com/folke/lazy.nvim) 的 Neovim 配置框架。这不是直接使用的配置，而是 LazyVim 的核心代码库。

## 重要说明

⚠️ **不要直接使用此仓库** - 这是 LazyVim 的核心库，用户应该使用 [LazyVim Starter](https://github.com/LazyVim/starter) 模板。

## 开发命令

### 代码格式化

- **StyLua**: `stylua .` - 格式化所有 Lua 文件
- **Selene**: `selene .` - Lua 静态分析

### 测试

- **运行测试**: `./scripts/test` - 使用 minit 测试框架运行测试

### 配置文件

- **StyLua 配置**: `stylua.toml` - 使用 2 空格缩进，120 字符列宽
- **Selene 配置**: `selene.toml` - 使用 Vim 标准，允许混合表

## 项目结构

```
lua/lazyvim/
├── config/          # 核心配置 (autocmds, keymaps, options)
├── plugins/         # 插件配置
│   ├── extras/      # 可选额外功能
│   │   ├── ai/      # AI 相关插件
│   │   ├── coding/  # 编码工具
│   │   ├── editor/  # 编辑器增强
│   │   ├── lang/    # 语言支持
│   │   └── util/    # 实用工具
│   └── lsp/         # LSP 配置
└── util/            # 工具函数
```

## 关键文件

- `lua/lazyvim/config/init.lua` - 主配置入口
- `lua/lazyvim/plugins/init.lua` - 插件管理
- `lua/lazyvim/util/init.lua` - 工具函数

## 开发注意事项

1. **遵循现有模式**: 保持代码风格与现有代码一致
2. **使用工具函数**: 优先使用 `LazyVim.util` 中的现有函数
3. **向后兼容**: 更改时考虑现有用户的配置
4. **文档**: 为新的配置选项添加类型注解和文档

## 测试策略

测试位于 `tests/` 目录，使用 minit 框架。运行测试前确保:

- 安装了必要的依赖
- 网络连接正常（测试会下载依赖）

