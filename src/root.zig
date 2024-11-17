const builtin = @import("builtin");
const std = @import("std");

const options = @import("zglfw_options");

comptime {
    _ = std.testing.refAllDeclsRecursive(@This());
}

extern fn glfwInit() i32;
extern fn glfwTerminate() void;
extern fn glfwPollEvents() void;
extern fn glfwWaitEvents() void;
extern fn glfwWaitEventsTimeout(timeout: f64) void;
extern fn glfwVulkanSupported() i32;
extern fn glfwGetTime() f64;
extern fn glfwSetTime(time: f64) void;
extern fn glfwRawMouseMotionSupported() i32;
extern fn glfwGetError(description: ?*?[*:0]const u8) i32;
extern fn glfwSetErrorCallback(callback: ?ErrorFn) ?ErrorFn;

// Window
extern fn glfwCreateWindow(
    width: i32,
    height: i32,
    title: [*:0]const u8,
    monitor: ?*GLFWMonitor,
    share: ?*GLFWwindow,
) ?*GLFWwindow;
extern fn glfwGetWindowAttrib(window: *GLFWwindow, attrib: Attribute) i32;
extern fn glfwSetWindowAttrib(window: *GLFWwindow, attrib: Attribute, value: i32) void;
extern fn glfwGetWindowUserPointer(window: *GLFWwindow) ?*anyopaque;
extern fn glfwSetWindowUserPointer(window: *GLFWwindow, pointer: ?*anyopaque) void;
extern fn glfwWindowShouldClose(window: *GLFWwindow) i32;
extern fn glfwSetWindowShouldClose(window: *GLFWwindow, should_close: i32) void;
extern fn glfwDestroyWindow(window: *GLFWwindow) void;
extern fn glfwSetWindowSizeLimits(window: *GLFWwindow, min_w: i32, min_h: i32, max_w: i32, max_h: i32) void;
extern fn glfwGetKey(window: *GLFWwindow, key: Key) Action;
extern fn glfwGetMouseButton(window: *GLFWwindow, button: MouseButton) Action;
extern fn glfwGetCursorPos(window: *GLFWwindow, xpos: *f64, ypos: *f64) void;
extern fn glfwGetFramebufferSize(window: *GLFWwindow, width: *i32, height: *i32) void;
extern fn glfwGetWindowSize(window: *GLFWwindow, width: *i32, height: *i32) void;
extern fn glfwSetWindowSize(window: *GLFWwindow, width: i32, height: i32) void;
extern fn glfwGetWindowPos(window: *GLFWwindow, xpos: *i32, ypos: *i32) void;
extern fn glfwSetWindowPos(window: *GLFWwindow, xpos: i32, ypos: i32) void;
extern fn glfwSetWindowTitle(window: *GLFWwindow, title: [*:0]const u8) void;
extern fn glfwFocusWindow(window: *GLFWwindow) void;
extern fn glfwSetFramebufferSizeCallback(window: *GLFWwindow, callback: ?FramebufferSizeFn) ?FramebufferSizeFn;
pub const FramebufferSizeFn = *const fn (
    window: *GLFWwindow,
    width: i32,
    height: i32,
) callconv(.C) void;
extern fn glfwSetWindowSizeCallback(window: *GLFWwindow, callback: ?WindowSizeFn) ?WindowSizeFn;
pub const WindowSizeFn = *const fn (
    window: *GLFWwindow,
    width: i32,
    height: i32,
) callconv(.C) void;
extern fn glfwSetWindowPosCallback(window: *GLFWwindow, callback: ?WindowPosFn) ?WindowPosFn;
pub const WindowPosFn = *const fn (
    window: *GLFWwindow,
    xpos: i32,
    ypos: i32,
) callconv(.C) void;
extern fn glfwSetWindowFocusCallback(window: *GLFWwindow, callback: ?WindowFocusFn) ?WindowFocusFn;
pub const WindowFocusFn = *const fn (
    window: *GLFWwindow,
    focused: i32,
) callconv(.C) void;
extern fn glfwSetWindowIconifyCallback(window: *GLFWwindow, callback: ?IconifyFn) ?IconifyFn;
pub const IconifyFn = *const fn (
    window: *GLFWwindow,
    iconified: i32,
) callconv(.C) void;
extern fn glfwSetWindowContentScaleCallback(window: *GLFWwindow, callback: ?WindowContentScaleFn) ?WindowContentScaleFn;
pub const WindowContentScaleFn = *const fn (
    window: *GLFWwindow,
    xscale: f32,
    yscale: f32,
) callconv(.C) void;
extern fn glfwSetKeyCallback(window: *GLFWwindow, callback: ?KeyFn) ?KeyFn;
pub const KeyFn = *const fn (
    window: *GLFWwindow,
    key: Key,
    scancode: i32,
    action: Action,
    mods: Mods,
) callconv(.C) void;
extern fn glfwSetCharCallback(window: *GLFWwindow, callback: ?CharFn) ?CharFn;
pub const CharFn = *const fn (
    window: *GLFWwindow,
    codepoint: u32,
) callconv(.C) void;
extern fn glfwSetDropCallback(window: *GLFWwindow, callback: ?DropFn) ?DropFn;
pub const DropFn = *const fn (
    window: *GLFWwindow,
    path_count: i32,
    paths: [*][*:0]const u8,
) callconv(.C) void;
extern fn glfwSetMouseButtonCallback(window: *GLFWwindow, callback: ?MouseButtonFn) ?MouseButtonFn;
pub const MouseButtonFn = *const fn (
    window: *GLFWwindow,
    button: MouseButton,
    action: Action,
    mods: Mods,
) callconv(.C) void;
extern fn glfwSetCursorPosCallback(window: *GLFWwindow, callback: ?CursorPosFn) ?CursorPosFn;
pub const CursorPosFn = *const fn (
    window: *GLFWwindow,
    xpos: f64,
    ypos: f64,
) callconv(.C) void;
extern fn glfwSetScrollCallback(window: *GLFWwindow, callback: ?ScrollFn) ?ScrollFn;
pub const ScrollFn = *const fn (
    window: *GLFWwindow,
    xoffset: f64,
    yoffset: f64,
) callconv(.C) void;
extern fn glfwSetCursorEnterCallback(window: *GLFWwindow, callback: ?CursorEnterFn) ?CursorEnterFn;
pub const CursorEnterFn = *const fn (
    window: *GLFWwindow,
    entered: i32,
) callconv(.C) void;

// Platform
extern fn glfwGetWin32Window(*GLFWwindow) ?std.os.windows.HWND;
extern fn glfwGetWaylandWindow(window: *GLFWwindow) ?*anyopaque;
extern fn glfwGetX11Window(window: *GLFWwindow) u32;
extern fn glfwGetCocoaWindow(window: *GLFWwindow) ?*anyopaque;

pub const GLFWMonitor = opaque {};
pub const GLFWwindow = opaque {};
pub const GlProc = *const anyopaque;
pub const ErrorFn = *const fn (
    error_code: i32,
    description: *?[:0]const u8,
) callconv(.C) void;

pub const Action = enum(i32) {
    release,
    press,
    repeat,
};

pub const MouseButton = enum(i32) {
    left,
    right,
    middle,
    four,
    five,
    six,
    seven,
    eight,
};

pub const Key = enum(i32) {
    unknown = -1,

    space = 32,
    apostrophe = 39,
    comma = 44,
    minus = 45,
    period = 46,
    slash = 47,
    zero = 48,
    one = 49,
    two = 50,
    three = 51,
    four = 52,
    five = 53,
    six = 54,
    seven = 55,
    eight = 56,
    nine = 57,
    semicolon = 59,
    equal = 61,
    a = 65,
    b = 66,
    c = 67,
    d = 68,
    e = 69,
    f = 70,
    g = 71,
    h = 72,
    i = 73,
    j = 74,
    k = 75,
    l = 76,
    m = 77,
    n = 78,
    o = 79,
    p = 80,
    q = 81,
    r = 82,
    s = 83,
    t = 84,
    u = 85,
    v = 86,
    w = 87,
    x = 88,
    y = 89,
    z = 90,
    left_bracket = 91,
    backslash = 92,
    right_bracket = 93,
    grave_accent = 96,
    world_1 = 161,
    world_2 = 162,

    escape = 256,
    enter = 257,
    tab = 258,
    backspace = 259,
    insert = 260,
    delete = 261,
    right = 262,
    left = 263,
    down = 264,
    up = 265,
    page_up = 266,
    page_down = 267,
    home = 268,
    end = 269,
    caps_lock = 280,
    scroll_lock = 281,
    num_lock = 282,
    print_screen = 283,
    pause = 284,
    F1 = 290,
    F2 = 291,
    F3 = 292,
    F4 = 293,
    F5 = 294,
    F6 = 295,
    F7 = 296,
    F8 = 297,
    F9 = 298,
    F10 = 299,
    F11 = 300,
    F12 = 301,
    F13 = 302,
    F14 = 303,
    F15 = 304,
    F16 = 305,
    F17 = 306,
    F18 = 307,
    F19 = 308,
    F20 = 309,
    F21 = 310,
    F22 = 311,
    F23 = 312,
    F24 = 313,
    F25 = 314,
    kp_0 = 320,
    kp_1 = 321,
    kp_2 = 322,
    kp_3 = 323,
    kp_4 = 324,
    kp_5 = 325,
    kp_6 = 326,
    kp_7 = 327,
    kp_8 = 328,
    kp_9 = 329,
    kp_decimal = 330,
    kp_divide = 331,
    kp_multiply = 332,
    kp_subtract = 333,
    kp_add = 334,
    kp_enter = 335,
    kp_equal = 336,
    left_shift = 340,
    left_control = 341,
    left_alt = 342,
    left_super = 343,
    right_shift = 344,
    right_control = 345,
    right_alt = 346,
    right_super = 347,
    menu = 348,
};

pub const Mods = packed struct(i32) {
    shift: bool = false,
    control: bool = false,
    alt: bool = false,
    super: bool = false,
    caps_lock: bool = false,
    num_lock: bool = false,
    _padding: i26 = 0,
};

pub const Attribute = enum(i32) {
    focused = 0x00020001,
    iconified = 0x00020002,
    resizable = 0x00020003,
    visible = 0x00020004,
    decorated = 0x00020005,
    auto_iconify = 0x00020006,
    floating = 0x00020007,
    maximized = 0x00020008,
    center_cursor = 0x00020009,
    transparent_framebuffer = 0x0002000A,
    hovered = 0x0002000B,
    focus_on_show = 0x0002000C,
};
