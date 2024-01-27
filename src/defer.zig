// go의 defer와 같은 기능
// 자랑글에서 go defer가 성능 구리다고 까던데.. 뭐가 다른지 나중에 찾아봐야겠음

const expect = @import("std").testing.expect;

test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        try expect(x == 5);
    }
    try expect(x == 7);
}

// defer 여러 번 하면 역순으로 감. LIFO
test "multi defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    try expect(x == 4.5);
}
