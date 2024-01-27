const std = @import("std");
const expect = std.testing.expect;

const Direction = enum { north, south, east, west };
const Value = enum(u2) { zero, one, two }; // enum(T) { } : T로 타입 지정 가능. 이건 C랑 유사.
test "enum ordinal value" {
    try expect(@intFromEnum(Value.zero) == 0); // 크으
    try expect(@intFromEnum(Value.one) == 1);
    try expect(@intFromEnum(Value.two) == 2);
}

const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    next, // 이것도 뭐 일반적임. 지정 안 하면 (이전 값 + 1)
};
test "set enum ordinal value" {
    try expect(@intFromEnum(Value2.hundred) == 100);
    try expect(@intFromEnum(Value2.thousand) == 1000);
    try expect(@intFromEnum(Value2.million) == 1000000);
    try expect(@intFromEnum(Value2.next) == 1000001);
}

const Suit = enum {
    var Joker: u32 = 0x1234; // 정적 변수도 ㄱㄴ
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool { // 메서드도 넣을 수 있음 ㅋㅋ
        return self == Suit.clubs;
    }
};
test "enum method" {
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades)); // 이게 뭐냐고 둘 중에 하나만 해놔야지 별걸 다 하네
    // 프로젝트 내에선 일관성 있게 하는 게 좋을듯
    // Suit 변수는 전자, Suit 리터럴에 대해서 하는 건 후자가 깔끔할듯 하다
}
