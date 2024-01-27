const std = @import("std");
const expect = std.testing.expect;

fn increment(num: *u8) void { // (*T)로 포인터 타입 지정하는 건 c랑 똑같음
    num.* += 1; // 역참조 문법은 별로임.. *num 돌려줘..
}
test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}
test "naughty pointer" {
    const x: u16 = 0;
    const y: *u8 = @ptrFromInt(x); // 이것도 DIB 임. 왜냐면 포인터는 0이나 null을 값으로 가질 수 없음.
    _ = y;
}

test "const pointers" {
    const x: u8 = 1;
    const y = &x;
    y.* += 1; // 상수를 가리키는 포인터를 역참조해도 값을 수정할 수 없음
    // 이럴 땐 *u8이 *const u8이 됨
}

// usize, isize는 포인터와 크기가 같음
// C++ size_t 랑 역할은 같은 거 같은데 뭔가 다르네
test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}

// Many-item Pointers
// *T: T에 대한 포인터
// [*]T: 여러 T에 대한 포인터. 그냥 포인터 배열 아님? 글로만 봐서 모르겠네
// many item 이지만 길이가 0이나 1도 될 수 있음
