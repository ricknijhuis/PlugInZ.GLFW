const std = @import("std");

pub fn PtrCast(Self: type) type {
    const info = @typeInfo(Self).@"struct";

    comptime {
        std.debug.assert(info.layout == .@"extern");
        std.debug.assert(info.fields.len == 1);
    }

    const Inner = info.fields[0].type;

    comptime {
        std.debug.assert(@sizeOf(Self) == @sizeOf(Inner));
        std.debug.assert(@alignOf(Self) == @alignOf(Inner));
        std.debug.assert(@typeInfo(Inner) == .pointer);
    }

    return struct {
        pub inline fn to(self: *Self) Inner {
            return @ptrCast(self);
        }

        pub inline fn toOptional(self: ?*Self) ?Inner {
            return @ptrCast(self);
        }

        pub inline fn from(data: Inner) *Self {
            return @ptrCast(@alignCast(data));
        }

        pub inline fn fromOptional(data: ?Inner) ?*Self {
            return @ptrCast(data);
        }
    };
}

pub fn Cast(Self: type, Extern: type) type {
    const info = @typeInfo(Self).@"struct";

    comptime {
        std.debug.assert(info.layout == .@"extern");
    }

    const Inner = Extern;

    comptime {
        std.debug.assert(@sizeOf(Self) == @sizeOf(Inner));
        std.debug.assert(@alignOf(Self) == @alignOf(Inner));
    }

    return struct {
        pub inline fn to(self: *const Self) *Inner {
            return @constCast(@ptrCast(self));
        }

        pub inline fn toOptional(self: ?*const Self) ?*const Inner {
            return @constCast(@ptrCast(self));
        }

        pub inline fn from(self: *const Inner) *Self {
            return @constCast(@ptrCast(@alignCast(self)));
        }

        pub inline fn fromMultiple(self: [*c]const Inner) *Self {
            return @constCast(@ptrCast(@alignCast(self)));
        }

        pub inline fn fromOptional(self: ?*const Inner) ?*const Self {
            return @ptrCast(self);
        }
    };
}
