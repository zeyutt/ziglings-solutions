# Ziglings Notes

## 📚 关于 Notes 文件夹

`notes` 文件夹包含对 `exercises` 文件夹中部分练习题的补充理解示例。这些 note 文件提供了更详细的解释、扩展示例和深入分析，帮助您更好地理解 Zig 语言的核心概念。

## 🎯 文件命名规则

Notes 文件采用以下命名规则：
```
{exercise_number}_{exercise_name}_note.zig
```

例如：
- `exercises/072_comptime7.zig` → `notes/072_comptime7_note.zig`
- `exercises/071_comptime6.zig` → `notes/071_comptime6_note.zig`

## 🚀 如何使用

### 运行单个 Note 文件

```bash
# 进入 notes 目录
cd notes

# 运行特定的 note 文件
zig run 072_comptime7_note.zig

# 或者从项目根目录运行
zig run notes/072_comptime7_note.zig
```

### 编译和测试

```bash
# 编译 note 文件
zig build-exe 072_comptime7_note.zig

# 运行测试（如果包含测试）
zig test 072_comptime7_note.zig
```

## 📖 学习建议

1. **先完成练习**：建议先尝试完成对应的 `exercises` 文件
2. **参考 Notes**：如果遇到困难或想深入理解，查看对应的 note 文件
3. **动手实践**：运行 note 文件，观察输出，理解概念
4. **对比学习**：将 exercise 和 note 进行对比，加深理解

## 📂 当前可用的 Notes

- `072_comptime7_note.zig` - 编译时计算和字符处理详解

## 🤝 贡献

如果您想为某个练习题添加补充说明，欢迎按照命名规则创建对应的 note 文件！

## 📝 注意事项

- Notes 文件是对 exercises 的补充，不是替代
- 每个 note 文件都可以独立运行
- Notes 文件包含详细的注释和解释
- 建议按顺序学习，先练习后参考

---

💡 **提示**: 这些 note 文件是学习 Zig 的绝佳补充资源，充分利用它们来提升您的编程技能！