const std = @import("std");
const expect = std.testing.expect;

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};

const AllocationError = error{OutOfMemory};
test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.OutOfMemory; // 뭐지 이름 같으면 변환 되나 봄 ㅋㅋ
    try expect(err == FileOpenError.OutOfMemory);
}

fn doSomething() !i32 {
    return 5;
}

test "error union" {
    const maybe_error: AllocationError!u16 = 10; // 에러!타입 - 에러이거나 타입이거나
    const no_error = maybe_error catch 0; // catch : 좌변이 에러 타입이면 우변의 값으로 evalutate

    // 우변에 값이 아닌 요런 것도 됨.
    maybe_error catch return;
    maybe_error catch doSomething();
    maybe_error catch if (doSomething() < 10) {
        std.debug.print("less than 10");
    };

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| { // capturing 문법. 다른 파트에서 자세히 할 거임
        try expect(err == error.Oops); // try 는 뭐냐면 에러 타입이면 그대로 error값 return해줌
        return;
    };
}

fn failFn() error{Oops}!i32 {
    try failingFunction();
    return 12;
}

test "try" {
    const v = failFn() catch |err| {
        try expect(err == error.Oops);
        return;
    };
    try expect(v == 12); // is never reached
}

// defer인데 이제 에러 나면서 return할 때만 실행하는
var problems: u32 = 98;
fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}
test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
        return;
    };
}

fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    //type coercion successfully takes place
    const x: error{AccessDenied}!void = createFile();

    //Zig does not let us ignore error unions via _ = x;
    //we must unwrap it with "try", "catch", or "if" by any means
    // 대충 어떻게든 handle해야 한다는 내용
    _ = x catch {};
}

const A = error{ NotDir, PathNotFound };
const B = error{ OutOfMemory, PathNotFound };
const C = A || B;
// 모든 에러 커버 가능한 anyerror도 있음. 안 쓰는 게 좋긴 함.
