const std = @import("std");

fn main() !void {
    const a = [5]u8{ 'h', 'e', 'l', 'l', 'o' }; // 길이 명시. 값 안 맞으면 에러남. 나중에 좀 더 조사
    _ = a; // autofix
    const b = [_]u8{ 'w', 'o', 'r', 'l', 'd' }; // 길이 추론. []로 쓸 수 있으면 더 좋았을듯
    std.debug.print("b size: {d}", .{b.len});
}
