const std = @import("std");
const print = std.debug.print;
const sentinel = std.meta.sentinel;

pub fn explainSentinel() void {
    print("=== Sentinel 概念解释 ===\n", .{});

    // 想象一个字母序列，用 'S' 作为结束标记
    const letters = "abcdefS";
    print("字母序列: {s}\n", .{letters});
    print("这里 'S' 就是 sentinel，表示序列结束\n", .{});

    // 但如果序列本身需要包含 'S'，这就有问题了
    const problematic = "abcSdefS"; // 第一个 S 会被误认为结束
    print("问题序列: {s}\n", .{problematic});
    print("第一个 'S' 会被错误地认为是结束标记\n", .{});
}

pub fn whyZeroSentinel() void {
    print("\n=== 为什么选择 0 作为 Sentinel ===\n", .{});

    // 1. 历史原因：C 语言的字符串就是用 0 结尾的
    const c_style_string = "Hello\x00"; // \x00 是 null 字符
    print("C 风格字符串: {s}\n", .{c_style_string});

    // 2. 0 在很多数据类型中都是有效的 sentinel
    const numbers = [_:0]u32{ 1, 2, 3, 4, 5 }; // 0 结尾的数字数组
    print("数字数组: {any}\n", .{numbers});

    // 3. 内存中 0 是常见的"空"值
    print("0 在内存中表示'无数据'或'空'\n", .{});
}

pub fn customSentinels() void {
    print("\n=== 自定义 Sentinel 示例 ===\n", .{});

    // 使用 999 作为 sentinel
    const nums_999 = [_:999]u32{ 1, 2, 999, 4, 5 };
    print("使用 999 作为 sentinel: {any}\n", .{nums_999});

    // 使用 'X' 作为字符 sentinel
    const chars = [_:'X']u8{ 'a', 'b', 'X', 'd' };
    print("使用 'X' 作为 sentinel: {any}\n", .{chars});

    // 使用 -1 作为 sentinel（对于有符号整数）
    const signed_nums = [_:-1]i32{ 10, 20, -1, 40 };
    print("使用 -1 作为 sentinel: {any}\n", .{signed_nums});

    // 甚至可以使用浮点数作为 sentinel
    const floats = [_:99.9]f32{ 1.1, 99.9, 3.3 };
    print("使用 99.9 作为 sentinel: {any}\n", .{floats});
}

// ============================================================================
// 🎯 修复：通用的 sentinel 检测和打印函数
// ============================================================================

/// 通用的 sentinel 检测和打印函数 - 修复版本
fn printUntilSentinel(ptr: anytype, comptime sentinel_val: @TypeOf(ptr[0])) void {
    // const T = @TypeOf(ptr[0]);
    print("打印到 sentinel ({any}) 为止: ", .{sentinel_val});
    var i: usize = 0;
    while (ptr[i] != sentinel_val) : (i += 1) {
        print("{any} ", .{ptr[i]});
    }
    print("-> 遇到 sentinel，停止\n", .{});
}

/// 专门处理字符串的函数
pub fn printStringUntilNull(str: [*:0]const u8) void {
    print("字符串打印到 null 为止: \"", .{});
    var i: usize = 0;
    while (str[i] != 0) : (i += 1) {
        print("{c}", .{str[i]});
    }
    print("\" -> 遇到 null，停止\n", .{});
}

// 为了更好的类型安全，我们提供具体类型的版本
fn printU32UntilSentinel(ptr: [*:0]const u32) void {
    print("打印 u32 到 sentinel (0) 为止: ", .{});
    var i: usize = 0;
    while (ptr[i] != 0) : (i += 1) {
        print("{} ", .{ptr[i]});
    }
    print("-> 遇到 sentinel，停止\n", .{});
}

fn printU8UntilSentinel(ptr: [*:'X']const u8, comptime sentinel_val: u8) void {
    print("打印 u8 到 sentinel ('{c}') 为止: ", .{sentinel_val});
    var i: usize = 0;
    while (ptr[i] != sentinel_val) : (i += 1) {
        print("{c} ", .{ptr[i]});
    }
    print("-> 遇到 sentinel，停止\n", .{});
}

fn printI32UntilSentinel(ptr: [*:-1]const i32) void {
    print("打印 i32 到 sentinel (-1) 为止: ", .{});
    var i: usize = 0;
    while (ptr[i] != -1) : (i += 1) {
        print("{} ", .{ptr[i]});
    }
    print("-> 遇到 sentinel，停止\n", .{});
}

fn printF32UntilSentinel(ptr: [*:99.9]const f32) void {
    print("打印 f32 到 sentinel (99.9) 为止: ", .{});
    var i: usize = 0;
    while (ptr[i] != 99.9) : (i += 1) {
        print("{d:.1} ", .{ptr[i]});
    }
    print("-> 遇到 sentinel，停止\n", .{});
}

pub fn testSentinelPrinting() void {
    print("\n=== 测试只打印到 Sentinel 为止 ===\n", .{});

    // 测试1: 数字数组，sentinel 为 0
    var nums_with_zero = [_:0]u32{ 10, 20, 30, 0, 40, 50 };
    print("原始数组: {any}\n", .{nums_with_zero});
    const nums_ptr: [*:0]u32 = &nums_with_zero;
    printU32UntilSentinel(nums_ptr);

    // 测试2: 字符数组，sentinel 为 'X'
    var chars_with_x = [_:'X']u8{ 'a', 'b', 'c', 'X', 'd', 'e' };
    print("\n原始字符数组: {any}\n", .{chars_with_x});
    const chars_ptr: [*:'X']u8 = &chars_with_x;
    printU8UntilSentinel(chars_ptr, 'X');

    // 测试3: 有符号数字，sentinel 为 -1
    var signed_with_neg1 = [_:-1]i32{ 100, 200, -1, 300, 400 };
    print("\n原始有符号数组: {any}\n", .{signed_with_neg1});
    const signed_ptr: [*:-1]i32 = &signed_with_neg1;
    printI32UntilSentinel(signed_ptr);

    // 测试4: 浮点数，sentinel 为 99.9
    var floats_with_999 = [_:99.9]f32{ 1.1, 2.2, 99.9, 4.4, 5.5 };
    print("\n原始浮点数组: {any}\n", .{floats_with_999});
    const floats_ptr: [*:99.9]f32 = &floats_with_999;
    printF32UntilSentinel(floats_ptr);

    // 测试5: 字符串（null 结尾）
    var hello_with_stuff = [_:0]u8{ 'H', 'e', 'l', 'l', 'o', 0, 'W', 'o', 'r', 'l', 'd' };
    print("\n原始字符串数组: {any}\n", .{hello_with_stuff});
    const hello_ptr: [*:0]u8 = &hello_with_stuff;
    printStringUntilNull(hello_ptr);

    // 测试6: 修改数组中的值来测试动态 sentinel
    print("\n=== 动态修改测试 ===\n", .{});
    var dynamic_nums = [_:999]u32{ 10, 20, 30, 40, 50 };

    print("初始状态:\n", .{});
    print("  完整数组: {any}\n", .{dynamic_nums});
    // 使用通用函数测试
    printUntilSentinel(&dynamic_nums, 999);

    // 在中间插入 sentinel
    dynamic_nums[2] = 999;
    print("\n在索引 2 处插入 sentinel 后:\n", .{});
    print("  完整数组: {any}\n", .{dynamic_nums});
    printUntilSentinel(&dynamic_nums, 999);

    // 恢复并在更早位置插入 sentinel
    dynamic_nums[2] = 30;
    dynamic_nums[1] = 999;
    print("\n在索引 1 处插入 sentinel 后:\n", .{});
    print("  完整数组: {any}\n", .{dynamic_nums});
    printUntilSentinel(&dynamic_nums, 999);
}

pub fn testSentinelWithRealStrings() void {
    print("\n=== 真实字符串 Sentinel 测试 ===\n", .{});

    // Zig 字符串字面量自动以 null 结尾
    const message1 = "Hello, Zig!";
    const message2 = "这是中文字符串";
    const message3 = "Mixed 混合 String!";

    print("测试字符串字面量（自动 null 结尾）:\n", .{});
    print("  message1: \"{s}\"\n", .{message1});
    printStringUntilNull(message1.ptr);

    print("  message2: \"{s}\"\n", .{message2});
    printStringUntilNull(message2.ptr);

    print("  message3: \"{s}\"\n", .{message3});
    printStringUntilNull(message3.ptr);

    // 手动创建包含中间 null 的字符串
    var manual_string = [_:0]u8{ 'A', 'B', 'C', 0, 'D', 'E', 'F' };
    print("\n手动字符串（中间包含 null）:\n", .{});
    print("  完整数组: {any}\n", .{manual_string});
    printStringUntilNull(&manual_string);
}

pub fn testSentinelTypeSystem() void {
    print("\n=== Sentinel 类型系统测试 ===\n", .{});

    // 使用编译时反射获取 sentinel 值
    var test_array = [_:42]u32{ 1, 2, 3, 42, 5, 6 };
    const array_type = @TypeOf(test_array);
    const ptr_type = @TypeOf(&test_array);

    print("数组类型: {any}\n", .{array_type});
    print("指针类型: {any}\n", .{ptr_type});

    // 使用 std.meta.sentinel 获取 sentinel 值
    const array_sentinel = std.meta.sentinel(array_type);
    const ptr_sentinel = std.meta.sentinel(ptr_type);

    print("数组的 sentinel: {any}\n", .{array_sentinel});
    print("指针的 sentinel: {any}\n", .{ptr_sentinel});

    // 动态使用 sentinel 值
    if (array_sentinel) |s| {
        print("使用反射得到的 sentinel ({}) 进行打印:\n", .{s});
        printUntilSentinel(&test_array, s); // 1 2 3
    }
}

// 修复：通用的长度计算函数
fn sentinelLength(ptr: anytype, comptime sentinel_val: @TypeOf(ptr[0])) usize {
    var len: usize = 0;
    while (ptr[len] != sentinel_val) : (len += 1) {}
    return len;
}

// 高级用法：多种 sentinel 类型的统一处理
pub fn advancedSentinelUsage() void {
    print("\n=== 高级 Sentinel 用法 ===\n", .{});

    // 测试不同类型的长度计算
    var nums = [_:0]u32{ 10, 20, 30, 0, 40 };
    var chars = [_:'#']u8{ 'a', 'b', 'c', '#', 'd' };
    var floats = [_:-1.0]f32{ 1.5, 2.5, -1.0, 3.5 };

    const nums_len = sentinelLength(&nums, 0);
    const chars_len = sentinelLength(&chars, '#');
    const floats_len = sentinelLength(&floats, -1.0);

    print("数字数组到 sentinel 的长度: {}\n", .{nums_len});
    print("字符数组到 sentinel 的长度: {}\n", .{chars_len});
    print("浮点数组到 sentinel 的长度: {}\n", .{floats_len});

    // 验证长度计算
    print("\n验证:\n", .{});
    print("  数字数组: {any} -> 前 {} 个元素\n", .{ nums, nums_len });
    print("  字符数组: {any} -> 前 {} 个元素\n", .{ chars, chars_len });
    print("  浮点数组: {any} -> 前 {} 个元素\n", .{ floats, floats_len });
}

pub fn analyzeOriginalCode() void {
    print("\n=== 原始代码分析 ===\n", .{});

    // 创建一个以 0 为 sentinel 的数组
    var nums = [_:0]u32{ 1, 2, 3, 4, 5, 6 };
    print("原始数组: {any}\n", .{nums});
    print("数组长度: {} (不包括 sentinel)\n", .{nums.len});
    print("实际存储: {} 个元素 (包括 sentinel)\n", .{nums.len + 1});

    // 转换为多项指针
    const ptr: [*:0]u32 = &nums;
    print("多项指针类型: {any}\n", .{@TypeOf(ptr)});

    // 在中间插入 sentinel 值
    nums[3] = 0; // 这是"淘气"的行为
    print("修改后数组: {any}\n", .{nums});

    print("\n现在数组中间包含了 sentinel 值！\n", .{});

    // 演示不同的遍历行为
    print("\n=== 遍历行为对比 ===\n", .{});

    // 数组遍历：会打印所有元素，包括中间的 0
    print("数组遍历: ", .{});
    for (nums) |val| {
        print("{} ", .{val});
    }
    print("\n", .{});

    // 指针遍历：遇到第一个 0 就停止
    print("指针遍历: ", .{});
    var i: usize = 0;
    while (ptr[i] != 0) : (i += 1) {
        print("{} ", .{ptr[i]});
    }
    print("\n", .{});

    // 使用我们的新函数
    print("使用新函数: ", .{});
    printU32UntilSentinel(ptr);
}

pub fn practicalApplications() void {
    print("\n=== Sentinel 的实际应用 ===\n", .{});

    // 1. 字符串处理
    const message = "Hello, Zig!";
    print("字符串: \"{s}\" (自动以 0 结尾)\n", .{message});

    // 2. 动态数据结构
    const dynamic_data = [_:255]u8{ 1, 2, 3, 4, 5 }; // 255 作为结束标记
    print("动态数据: {any}\n", .{dynamic_data});

    // 3. 协议数据包
    const packet = [_:0xFF]u8{ 0x01, 0x02, 0x03, 0x04 }; // 0xFF 作为包结束
    print("数据包: {any}\n", .{packet});

    // 4. 命令行参数风格
    const args = [_]?[]const u8{ "program", "arg1", "arg2" };
    print("参数列表: {any}\n", .{args});
}

pub fn typeSafety() void {
    print("\n=== Sentinel 的类型安全 ===\n", .{});

    // ✅ 正确：sentinel 类型与数据类型匹配
    var correct_nums = [_:0]u32{ 1, 2, 3 };
    print("正确的类型匹配: {any}\n", .{correct_nums});

    // ❌ 编译错误：类型不匹配
    // var wrong = [_:'0']u32{1, 2, 3};  // 字符 '0' 不能作为 u32 的 sentinel

    print("Sentinel 必须与数据类型完全匹配！\n", .{});

    // 演示 sentinel 函数的使用
    const nums_sentinel = @import("std").meta.sentinel(@TypeOf(&correct_nums));
    print("提取的 sentinel 值: {any}\n", .{nums_sentinel});
}

pub fn main() void {
    explainSentinel();
    whyZeroSentinel();
    customSentinels();

    // 🎯 新增的测试函数
    testSentinelPrinting();
    testSentinelWithRealStrings();
    testSentinelTypeSystem();
    advancedSentinelUsage();

    analyzeOriginalCode();
    practicalApplications();
    typeSafety();

    print("\n=== 总结 ===\n", .{});
    print("1. Sentinel 是标记数据结束的特殊值\n", .{});
    print("2. 0 是最常用的 sentinel，但完全可以自定义\n", .{});
    print("3. Sentinel 必须与数据类型匹配\n", .{});
    print("4. 数组遍历会包含所有元素，指针遍历在第一个 sentinel 处停止\n", .{});
    print("5. 可以使用指针来实现'只打印到 sentinel 为止'的功能\n", .{});
    print("6. Zig 提供了强大的编译时反射来处理 sentinel 类型\n", .{});
}
