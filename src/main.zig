const std = @import("std");
const expect = @import("std").testing.expect;

fn testfunc() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    try stdout.writeStruct(Vec3{ .x = 0, .y = 1, .z = 2 });

    try bw.flush(); // don't forget to flush!

    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) {
        sum += i;
        std.debug.print("Value: {d}, {d}\n", .{ sum, i });
    }
    // try expect(sum == 55);

    const string = [_]u8{ 'a', 'b', 'c' };

    for (string, 0..) |ch, idx| {
        std.debug.print("Value: {c} {d}\n", .{ ch, idx });
    }

    for (string) |_| {}

    const AllocationError = error{OutOfMemory};

    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);

    const pos = Vec3{ .x = 1, .y = 1, .z = 1 };
    const pos2 = Vec3{ .x = 5, .y = 0, .z = 4 };
    _ = pos.distanceTo(pos2);
}

pub fn main() void {
    const a: i32 = 6;
    const b: i32 = 3;
    var x: i32 = 0;
    var i: i32 = 0;
    while (i < b) {
        x += 1;
        if (x > a) {
            std.debug.print("{d}", .{0});
            return;
        }
        if (@mod(a, x) == 0) {
            i += 1;
        }
    }
    std.debug.print("{d}", .{x});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,
    fn distanceTo(self: *const Vec3, rhs: Vec3) f32 {
        const dx = self.x - rhs.x;
        const dy = self.y - rhs.y;
        const dz = self.z - rhs.z;
        return @sqrt(dx * dx + dy * dy + dz * dz);
    }
};

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    // defer problems += 1;

    try failingFunction();
}
const Tag = enum { a, b, c };
const Tagged2 = union(enum) { a: u8, b: f32, c: bool, none };
const AbilitiyValue = union(enum) { a: u8, b: f32, c: bool, none };
test "simple union" {
    var result = AbilitiyValue{ .a = 123 };
    result.a = 3;
    switch (result) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*boolean| boolean.* = !boolean.*,
        .none => |*voidValue| voidValue.*,
    }
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
        return;
    };
}

test "@intCast" {
    const x: u64 = 2000;
    const y: u8 = @intCast(x);
    try expect(@TypeOf(y) == u8);
}
