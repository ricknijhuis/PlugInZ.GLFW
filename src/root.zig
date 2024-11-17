const builtin = @import("builtin");
const std = @import("std");
const assert = std.debug.assert;

const options = @import("zglfw_options");

comptime {
    _ = std.testing.refAllDeclsRecursive(@This());
}

// library functions
pub fn init() Error!void {
    if (glfwInit() != 0) return;
    try getError();
    unreachable;
}
extern fn glfwInit() i32;

pub const terminate = glfwTerminate;
extern fn glfwTerminate() void;

pub const pollEvents = glfwPollEvents;
extern fn glfwPollEvents() void;

pub const waitEvents = glfwWaitEvents;
extern fn glfwWaitEvents() void;

pub const waitEventsTimeout = glfwWaitEventsTimeout;
extern fn glfwWaitEventsTimeout(timeout: f64) void;

pub fn isVulkanSupported() bool {
    return if (glfwVulkanSupported() == 0) false else true;
}
extern fn glfwVulkanSupported() i32;

pub fn getRequiredInstanceExtensions() Error![][*:0]const u8 {
    var count: u32 = 0;
    if (glfwGetRequiredInstanceExtensions(&count)) |extensions| {
        return @as([*][*:0]const u8, @ptrCast(extensions))[0..count];
    }
    try getError();
    return error.APIUnavailable;
}
extern fn glfwGetRequiredInstanceExtensions(count: *u32) ?*?[*:0]const u8;

/// `pub fn getTime() f64`
pub const getTime = glfwGetTime;
extern fn glfwGetTime() f64;

/// `pub fn setTime(time: f64) void`
pub const setTime = glfwSetTime;
extern fn glfwSetTime(time: f64) void;

pub fn getError() Error!void {
    return convertError(glfwGetError(null));
}
extern fn glfwGetError(description: ?*?[*:0]const u8) i32;

pub const Error = error{
    NotInitialized,
    NoCurrentContext,
    InvalidEnum,
    InvalidValue,
    OutOfMemory,
    APIUnavailable,
    VersionUnavailable,
    PlatformError,
    FormatUnavailable,
    NoWindowContext,
    CursorUnavailable,
    FeatureUnavailable,
    FeatureUnimplemented,
    PlatformUnavailable,
    Unknown,
};

fn convertError(e: i32) Error!void {
    return switch (e) {
        0 => {},
        0x00010001 => Error.NotInitialized,
        0x00010002 => Error.NoCurrentContext,
        0x00010003 => Error.InvalidEnum,
        0x00010004 => Error.InvalidValue,
        0x00010005 => Error.OutOfMemory,
        0x00010006 => Error.APIUnavailable,
        0x00010007 => Error.VersionUnavailable,
        0x00010008 => Error.PlatformError,
        0x00010009 => Error.FormatUnavailable,
        0x0001000A => Error.NoWindowContext,
        0x0001000B => Error.CursorUnavailable,
        0x0001000C => Error.FeatureUnavailable,
        0x0001000D => Error.FeatureUnimplemented,
        0x0001000E => Error.PlatformUnavailable,
        else => Error.Unknown,
    };
}

pub fn maybeErrorString(str: *?[:0]const u8) Error!void {
    var c_str: ?[*:0]const u8 = undefined;
    convertError(glfwGetError(&c_str)) catch |err| {
        str.* = if (c_str) |s| std.mem.span(s) else null;
        return err;
    };
}
