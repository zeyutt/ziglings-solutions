const std = @import("std");
const print = std.debug.print;
// const print = @import("std").debug.print;

pub fn demonstrateCharToDigit() void {
    // 字符串中的 "3" 实际上是字符 '3'，不是数字 3
    const instructions = "+3 *5 -2 *2";

    // 让我们看看字符 '3' 的 ASCII 值
    const char_3 = instructions[1]; // 获取字符 '3'
    const char_0 = '0'; // 字符 '0'

    print("字符 '3' 的 ASCII 值: {}\n", .{char_3});
    print("字符 '0' 的 ASCII 值: {}\n", .{char_0});
    print("字符 '1' 的 ASCII 值: {}\n", .{'1'});
    print("字符 '9' 的 ASCII 值: {}\n", .{'9'});

    // 这就是为什么需要减去 '0'
    const digit_3 = char_3 - '0';
    print("数字值 3: {}\n", .{digit_3});
}

pub fn showAsciiTable() void {
    print("数字字符的 ASCII 编码:\n", .{});
    print("字符  |  ASCII值  |  数字值\n", .{});
    print("-----|----------|--------\n", .{});

    var i: u8 = 0;
    while (i <= 9) : (i += 1) {
        const char = '0' + i;
        print(" '{c}'  |    {}     |    {}\n", .{ char, char, char - '0' });
    }
}

pub fn explainConversion() void {
    const instructions = "+3 *5 -2 *2";

    print("指令字符串: \"{s}\"\n", .{instructions});
    print("字符索引:   ", .{});
    for (instructions, 0..) |_, idx| {
        print("{} ", .{idx});
    }
    print("\n", .{});

    print("字符内容:   ", .{});
    for (instructions) |char| {
        print("{c} ", .{char});
    }
    print("\n", .{});

    print("ASCII值:    ", .{});
    for (instructions) |char| {
        print("{} ", .{char});
    }
    print("\n\n", .{});

    // 演示每个指令的解析
    var i: usize = 0;
    while (i < instructions.len) : (i += 3) {
        const op = instructions[i];
        const digit_char = instructions[i + 1];
        const digit_value = digit_char - '0';

        print("指令 {}: 操作符='{c}', 字符='{c}', ASCII={}, 数字值={}\n", .{ i / 3 + 1, op, digit_char, digit_char, digit_value });
    }
}

pub fn whySubtraction() void {
    print("为什么使用减法转换?\n\n", .{});

    // 方法1: 减法（推荐）
    const char_5 = '5';
    const method1 = char_5 - '0';
    print("方法1 (减法): '{c}' - '0' = {} - {} = {}\n", .{ char_5, char_5, '0', method1 });

    // 方法2: 使用内置函数（更复杂）
    const method2 = std.fmt.charToDigit(char_5, 10) catch 0;
    print("方法2 (内置): charToDigit('{c}', 10) = {}\n", .{ char_5, method2 });

    // 方法3: switch 语句（冗长）
    const method3 = switch (char_5) {
        '0' => 0,
        '1' => 1,
        '2' => 2,
        '3' => 3,
        '4' => 4,
        '5' => 5,
        '6' => 6,
        '7' => 7,
        '8' => 8,
        '9' => 9,
        else => 0,
    };
    print("方法3 (switch): switch('{c}') = {}\n", .{ char_5, method3 });

    print("\n减法是最简洁和高效的方法！\n", .{});
}

pub fn originalCodeExplanation() void {
    const instructions = "+3 *5 -2 *2";
    var value: u32 = 0;
    comptime var i = 0;

    print("执行过程演示:\n", .{});
    print("初始值: {}\n", .{value});

    inline while (i < instructions.len) : (i += 3) {
        const op_char = instructions[i];
        const digit_char = instructions[i + 1];

        // 这里就是关键的转换
        const digit = digit_char - '0';

        print("步骤 {}: ", .{i / 3 + 1});
        print("'{c}'{c}' -> ", .{ op_char, digit_char });
        print("操作符='{c}', 数字={} -> ", .{ op_char, digit });

        switch (op_char) {
            '+' => {
                value += digit;
                print("{} + {} = {}\n", .{ value - digit, digit, value });
            },
            '-' => {
                value -= digit;
                print("{} - {} = {}\n", .{ value + digit, digit, value });
            },
            '*' => {
                value *= digit;
                print("{} * {} = {}\n", .{ value / digit, digit, value });
            },
            else => unreachable,
        }
    }

    print("最终结果: {}\n", .{value});
}

pub fn withoutSubtraction() void {
    const instructions = "+3 *5 -2 *2";
    var value: u32 = 0;
    comptime var i = 0;

    print("如果不减去 '0' 的错误示例:\n", .{});
    print("初始值: {}\n", .{value});

    inline while (i < instructions.len) : (i += 3) {
        const op_char = instructions[i];
        const digit_char = instructions[i + 1];

        // 错误：直接使用字符的 ASCII 值
        const wrong_digit = digit_char; // 这是 ASCII 值，不是数字值

        print("步骤 {}: ", .{i / 3 + 1});
        print("'{c}'{c}' -> ", .{ op_char, digit_char });
        print("错误的数字值={} (应该是 {})\n", .{ wrong_digit, digit_char - '0' });

        // 这会产生错误的结果！
        switch (op_char) {
            '+' => value += wrong_digit,
            '-' => value -= wrong_digit,
            '*' => value *= wrong_digit,
            else => unreachable,
        }
    }

    print("错误的最终结果: {} (应该是 21)\n", .{value});
}

pub fn main() void {
    print("=== 字符到数字转换详解 ===\n\n", .{});

    demonstrateCharToDigit();
    print("\n", .{});

    showAsciiTable();
    print("\n", .{});

    explainConversion();
    print("\n", .{});

    whySubtraction();
    print("\n", .{});

    print("=== 正确的执行 ===\n", .{});
    originalCodeExplanation();
    print("\n", .{});

    print("=== 错误示例 ===\n", .{});
    withoutSubtraction();
}
