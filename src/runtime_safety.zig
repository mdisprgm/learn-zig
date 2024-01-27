// 용어
// detectable illegal behavior: 일반적인 Undefined Behavior, 근데 이제 미리 Define해놓은(?)
// unreachable: 좀 신기한 키워드임. errors.zig에서 본 noreturn 타입.

const std = @import("std");
const expect = std.testing.expect;

test "out of bounds" {
    const a = [3]u8{ 1, 2, 3 };
    const index: u8 = 5;
    const b = a[index];
    _ = b;
}
test "out of bounds, no safety" {
    @setRuntimeSafety(false);
    const a = [4]u8{ 1, 2, 3, 4 };
    var index: u8 = 6;
    index += 1;
    const b = a[index];
    std.debug.print("{d}", .{b}); // 쓰레기 값 같은 게 나오긴 하는데 뭔가 일정함.. 나ㅏ중에 조사 좀.
}

test "unreachable" {
    const x: i32 = 1;
    const y: u32 = if (x == 2) 5 else unreachable; // unreachable에 오면 에러 남
    _ = y;
}

// unreachable 쓰임 예시
fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable, // 이런 건 가독성Up이라 개좋음
    };
}
test "unreachable switch" {
    try expect(asciiToUpper('a') == 'A');
    try expect(asciiToUpper('A') == 'A');
}
