// All function arguments are immutable
// if a copy is desired the user must explicitly make one.
// Unlike variables, which are snake_case, functions are camelCase.
// Here's an example of declaring and calling a simple function.

const expect = @import("std").testing.expect;

fn addFive(x: u32) u32 {
    return x + 5;
}

test "function" {
    const y = addFive(0);
    try expect(@TypeOf(y) == u32);
    try expect(y == 5);
}

// 재귀호출이 있으면 max stack size 컴파일러가 모름
// 없으면 알 수 있나봄
fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
    const x = fibonacci(10);
    try expect(x == 55);
}
