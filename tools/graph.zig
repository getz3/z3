const std = @import("std");
const polyrole = @import("polyrole");
const root_module = @import("root_module");
const EnterFsmState = root_module.EnterFsmState;
const Runner = root_module.Runner;

pub fn main(init: std.process.Init) !void {
    {
        const io = init.io;
        var gpa_instance = std.heap.DebugAllocator(.{}){};
        const gpa = gpa_instance.allocator();
        var graph = try polyrole.Graph.initWithFsm(gpa, EnterFsmState);
        defer graph.deinit();
        var stdout_buffer: [1024]u8 = undefined;
        var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
        const writer = &stdout_writer.interface;
        defer writer.flush() catch @panic("Failed to flush");

        var emoj_map: std.StringHashMap([]const u8) = .init(gpa);
        try emoj_map.put("client", "🅱️");
        try emoj_map.put("server", "🅰️");

        try graph.generateDot(&emoj_map, writer);
    }
}
