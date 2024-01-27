// Slices
// [*]T와 usize의 값을 가지는 구조체(pair)라고 봐도 된다고 함
// 타입 선언은 []T로 함. 모든 요소가 참조가 되어 동작하는듯
// 예를 들어 String 리터럴은 []const u8 타입이라고 할 수 있음

const std = @import("std");
const expect = std.testing.expect;

fn total(values: []const u8) usize {
    var sum: usize = 0;
    for (values) |v| sum += v;
    return sum;
}

test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    // [n..m] = [n]~[m-1]
    const slice = array[0..3]; // [0] ~ [2]
    try expect(total(slice) == 6);
}

test "slices 2" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..]; //n, m이 comptime 에 알 수 있으면
    try expect(@TypeOf(slice) == *const [5]u8); // 완전한 포인터 배열이 되며 따라서 길이도 명확해짐
    // [0..] : 처음부터 끝까지
    // 근데 [..2] 이런 건 안 되네. 굳이 필요 없긴 하지
}
