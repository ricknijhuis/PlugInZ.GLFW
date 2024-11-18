const builtin = @import("builtin");
const std = @import("std");

const options = @import("zglfw_options");

comptime {
    _ = std.testing.refAllDeclsRecursive(@This());
}

pub const init = glfwInit;
extern fn glfwInit() i32;

pub const terminate = glfwTerminate;
extern fn glfwTerminate() void;

pub const pollEvents = glfwPollEvents;
extern fn glfwPollEvents() void;

pub const vulkanSupported = glfwVulkanSupported;
extern fn glfwVulkanSupported() i32;

pub const getTime = glfwGetTime;
extern fn glfwGetTime() f64;

pub const setTime = glfwSetTime;
extern fn glfwSetTime(time: f64) void;

pub const rawMouseMotionSupported = glfwRawMouseMotionSupported;
extern fn glfwRawMouseMotionSupported() i32;

pub const getError = glfwGetError;
extern fn glfwGetError(description: ?*?[*:0]const u8) i32;

pub const setErrorCallback = glfwSetErrorCallback;
extern fn glfwSetErrorCallback(callback: ?ErrorFn) ?ErrorFn;

// Window
pub const createWindow = glfwCreateWindow;
extern fn glfwCreateWindow(
    width: i32,
    height: i32,
    title: [*:0]const u8,
    monitor: ?*Monitor,
    share: ?*Window,
) ?*Window;

pub const getWindowAttrib = glfwGetWindowAttrib;
extern fn glfwGetWindowAttrib(window: *Window, attrib: Attribute) i32;

pub const setWindowAttrib = glfwSetWindowAttrib;
extern fn glfwSetWindowAttrib(window: *Window, attrib: Attribute, value: i32) void;

pub const getWindowUserPointer = glfwGetWindowUserPointer;
extern fn glfwGetWindowUserPointer(window: *Window) ?*anyopaque;

pub const setWindowUserPointer = glfwSetWindowUserPointer;
extern fn glfwSetWindowUserPointer(window: *Window, pointer: ?*anyopaque) void;

pub const windowShouldClose = glfwWindowShouldClose;
extern fn glfwWindowShouldClose(window: *Window) i32;

pub const setWindowShouldClose = glfwSetWindowShouldClose;
extern fn glfwSetWindowShouldClose(window: *Window, should_close: i32) void;

pub const destroyWindow = glfwDestroyWindow;
extern fn glfwDestroyWindow(window: *Window) void;

pub const setWindowSizeLimits = glfwSetWindowSizeLimits;
extern fn glfwSetWindowSizeLimits(window: *Window, min_w: i32, min_h: i32, max_w: i32, max_h: i32) void;

pub const getKey = glfwGetKey;
extern fn glfwGetKey(window: *Window, key: Key) Action;

pub const getMouseButton = glfwGetMouseButton;
extern fn glfwGetMouseButton(window: *Window, button: MouseButton) Action;

pub const getCursorPos = glfwGetCursorPos;
extern fn glfwGetCursorPos(window: *Window, xpos: *f64, ypos: *f64) void;

pub const getFramebufferSize = glfwGetFramebufferSize;
extern fn glfwGetFramebufferSize(window: *Window, width: *i32, height: *i32) void;

pub const getWindowSize = glfwGetWindowSize;
extern fn glfwGetWindowSize(window: *Window, width: *i32, height: *i32) void;

pub const setWindowSize = glfwSetWindowSize;
extern fn glfwSetWindowSize(window: *Window, width: i32, height: i32) void;

pub const getWindowPos = glfwGetWindowPos;
extern fn glfwGetWindowPos(window: *Window, xpos: *i32, ypos: *i32) void;

pub const setWindowPos = glfwSetWindowPos;
extern fn glfwSetWindowPos(window: *Window, xpos: i32, ypos: i32) void;

pub const setWindowTitle = glfwSetWindowTitle;
extern fn glfwSetWindowTitle(window: *Window, title: [*:0]const u8) void;

pub const focusWindow = glfwFocusWindow;
extern fn glfwFocusWindow(window: *Window) void;

pub const setWindowCloseCallback = glfwSetWindowCloseCallback;
extern fn glfwSetWindowCloseCallback(window: *Window, callback: ?WindowCloseFn) ?WindowCloseFn;
pub const WindowCloseFn = *const fn (
    window: *Window,
) callconv(.C) void;

pub const setFramebufferSizeCallback = glfwSetFramebufferSizeCallback;
extern fn glfwSetFramebufferSizeCallback(window: *Window, callback: ?FramebufferSizeFn) ?FramebufferSizeFn;
pub const FramebufferSizeFn = *const fn (
    window: *Window,
    width: i32,
    height: i32,
) callconv(.C) void;

pub const setWindowSizeCallback = glfwSetWindowSizeCallback;
extern fn glfwSetWindowSizeCallback(window: *Window, callback: ?WindowSizeFn) ?WindowSizeFn;
pub const WindowSizeFn = *const fn (
    window: *Window,
    width: i32,
    height: i32,
) callconv(.C) void;

pub const setWindowPosCallback = glfwSetWindowPosCallback;
extern fn glfwSetWindowPosCallback(window: *Window, callback: ?WindowPosFn) ?WindowPosFn;
pub const WindowPosFn = *const fn (
    window: *Window,
    xpos: i32,
    ypos: i32,
) callconv(.C) void;

pub const setWindowFocusCallback = glfwSetWindowFocusCallback;
extern fn glfwSetWindowFocusCallback(window: *Window, callback: ?WindowFocusFn) ?WindowFocusFn;
pub const WindowFocusFn = *const fn (
    window: *Window,
    focused: i32,
) callconv(.C) void;

pub const setWindowIconifyCallback = glfwSetWindowIconifyCallback;
extern fn glfwSetWindowIconifyCallback(window: *Window, callback: ?IconifyFn) ?IconifyFn;
pub const IconifyFn = *const fn (
    window: *Window,
    iconified: i32,
) callconv(.C) void;

pub const setWindowContentScaleCallback = glfwSetWindowContentScaleCallback;
extern fn glfwSetWindowContentScaleCallback(window: *Window, callback: ?WindowContentScaleFn) ?WindowContentScaleFn;
pub const WindowContentScaleFn = *const fn (
    window: *Window,
    xscale: f32,
    yscale: f32,
) callconv(.C) void;

pub const setKeyCallback = glfwSetKeyCallback;
extern fn glfwSetKeyCallback(window: *Window, callback: ?KeyFn) ?KeyFn;
pub const KeyFn = *const fn (
    window: *Window,
    key: Key,
    scancode: i32,
    action: Action,
    mods: Mods,
) callconv(.C) void;

pub const setCharCallback = glfwSetCharCallback;
extern fn glfwSetCharCallback(window: *Window, callback: ?CharFn) ?CharFn;
pub const CharFn = *const fn (
    window: *Window,
    codepoint: u32,
) callconv(.C) void;

pub const setDropCallback = glfwSetDropCallback;
extern fn glfwSetDropCallback(window: *Window, callback: ?DropFn) ?DropFn;
pub const DropFn = *const fn (
    window: *Window,
    path_count: i32,
    paths: [*][*:0]const u8,
) callconv(.C) void;

pub const setMouseButtonCallback = glfwSetMouseButtonCallback;
extern fn glfwSetMouseButtonCallback(window: *Window, callback: ?MouseButtonFn) ?MouseButtonFn;
pub const MouseButtonFn = *const fn (
    window: *Window,
    button: MouseButton,
    action: Action,
    mods: Mods,
) callconv(.C) void;

pub const setCursorPosCallback = glfwSetCursorPosCallback;
extern fn glfwSetCursorPosCallback(window: *Window, callback: ?CursorPosFn) ?CursorPosFn;
pub const CursorPosFn = *const fn (
    window: *Window,
    xpos: f64,
    ypos: f64,
) callconv(.C) void;

pub const setScrollCallback = glfwSetScrollCallback;
extern fn glfwSetScrollCallback(window: *Window, callback: ?ScrollFn) ?ScrollFn;
pub const ScrollFn = *const fn (
    window: *Window,
    xoffset: f64,
    yoffset: f64,
) callconv(.C) void;

pub const setCursorEnterCallback = glfwSetCursorEnterCallback;
extern fn glfwSetCursorEnterCallback(window: *Window, callback: ?CursorEnterFn) ?CursorEnterFn;
pub const CursorEnterFn = *const fn (
    window: *Window,
    entered: i32,
) callconv(.C) void;

pub const windowHint = glfwWindowHint;
extern fn glfwWindowHint(WindowHint, value: i32) void;

// Platform
pub const getWin32Window = glfwGetWin32Window;
extern fn glfwGetWin32Window(*Window) ?std.os.windows.HWND;

pub const getWaylandWindow = glfwGetWaylandWindow;
extern fn glfwGetWaylandWindow(window: *Window) ?*anyopaque;

pub const getX11Window = glfwGetX11Window;
extern fn glfwGetX11Window(window: *Window) u32;

pub const getCocoaWindow = glfwGetCocoaWindow;
extern fn glfwGetCocoaWindow(window: *Window) ?*anyopaque;

pub fn convertToError(e: i32) Error!void {
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

pub const Monitor = opaque {};
pub const Window = opaque {};
pub const GlProc = *const anyopaque;
pub const ErrorFn = *const fn (
    error_code: i32,
    description: *?[:0]const u8,
) callconv(.C) void;

pub const ClientApi = enum(i32) {
    no_api = 0,
    opengl_api = 0x00030001,
    opengl_es_api = 0x00030002,
};

pub const WindowHint = enum(i32) {
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
    mouse_passthrough = 0x0002000D,
    position_x = 0x0002000E,
    position_y = 0x0002000F,
    red_bits = 0x00021001,
    green_bits = 0x00021002,
    blue_bits = 0x00021003,
    alpha_bits = 0x00021004,
    depth_bits = 0x00021005,
    stencil_bits = 0x00021006,
    // ACCUM_*_BITS/AUX_BUFFERS are deprecated
    stereo = 0x0002100C,
    samples = 0x0002100D,
    srgb_capable = 0x0002100E,
    refresh_rate = 0x0002100F,
    doublebuffer = 0x00021010,
    client_api = 0x00022001,
    context_version_major = 0x00022002,
    context_version_minor = 0x00022003,
    context_revision = 0x00022004,
    context_robustness = 0x00022005,
    opengl_forward_compat = 0x00022006,
    opengl_debug_context = 0x00022007,
    opengl_profile = 0x00022008,
    context_release_behaviour = 0x00022009,
    context_no_error = 0x0002200A,
    context_creation_api = 0x0002200B,
    scale_to_monitor = 0x0002200C,
    scale_framebuffer = 0x0002200D,
    cocoa_retina_framebuffer = 0x00023001,
    cocoa_frame_name = 0x00023002,
    cocoa_graphics_switching = 0x00023003,
    x11_class_name = 0x00024001,
    x11_instance_name = 0x00024002,
    win32_keyboard_menu = 0x00025001,
    win32_showdefault = 0x00025002,
    wayland_app_id = 0x00026001,
};

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
