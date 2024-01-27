fn run() !void {
    const constant = 1;
    _ = constant;

    // 타입 명시 안 하면 comptime 취급돼서 const 쓰라고 함.. runtime에 값 변경되는 코드 있어도 그럼. 융통성 없네
    var variable: i32 = 5;
    variable += 3;

    // 형변환. 좀 재밌는 모양이긴 함
    const inferred_constant = @as(i32, 5);
    _ = inferred_constant;
    var inferred_variable = @as(u32, 5000);
    inferred_variable /= 2;
}
