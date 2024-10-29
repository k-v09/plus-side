const std = @import("std");

pub fn getInput(allocator: std.mem.Allocator, prompt: []const u8) ![]const u8 {
    const stdin = std.io.getStdIn();
    const stdout = std.io.getStdOut();
    var buf_reader = std.io.bufferedReader(stdin.reader());
    var reader = buf_reader.reader();
    try stdout.writer().writeAll(prompt);
    const input = try reader.readUntilDelimiterAlloc(allocator, '\n', 1024);
    return input;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const name = try getInput(allocator, "What's your name: ");
    defer allocator.free(name);
    const favorite_color = try getInput(allocator, "What's your favorite color: ");
    defer allocator.free(favorite_color);

    const stdout = std.io.getStdOut();
    try stdout.writer().print("Heyooo {s}! I like {s} too! Even thoguh I'm a computer\n", .{ name, favorite_color });
}
