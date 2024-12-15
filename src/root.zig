const std = @import("std");
const builtin = @import("builtin");
const err = @import("error.zig");
const c = @cImport({
    @cDefine("GLFW_INCLUDE_VULKAN", "1");
    @cDefine("GLFW_INCLUDE_NONE", "1");
    @cInclude("glfw3.h");
});

const Cast = @import("cast.zig").Cast;
const PtrCast = @import("cast.zig").PtrCast;
const GLFWError = @import("error.zig").GLFWError;

fn initHint(hint: InitHint, value: anytype) void {
    comptime {
        switch (hint) {
            .platform => {
                std.debug.assert(@TypeOf(value) == PlatformHint, "expected a PlatformHint");
            },
            .wayland_libdecor => {
                std.debug.assert(@TypeOf(value) == WaylandLibDecor, "expected a WaylandLibDecor");
            },
            .angle_platform_type => {
                std.debug.assert(@TypeOf(value) == AnglePlatformType, "expected a AnglePlatformType");
            },
            else => {
                std.debug.assert(@TypeOf(value) == bool, "expected a bool");
            },
        }
    }

    switch (@typeInfo(@TypeOf(value))) {
        .int, .comptime_int => {
            c.glfwInitHint(@intFromEnum(hint), @as(c_int, @intCast(value)));
        },
        .bool => c.glfwInitHint(@intFromEnum(hint), @as(c_int, @intCast(@intFromBool(value)))),
        else => @compileError("expected a int or bool, got " ++ @typeName(@TypeOf(value))),
    }
}

pub inline fn init() GLFWError!void {
    if (c.glfwInit() != c.GLFW_TRUE) {
        try err.any();
        return GLFWError.UnknownError;
    }
}

pub inline fn deinit() void {
    c.glfwTerminate();
}

pub inline fn pollEvents() void {
    c.glfwPollEvents();
}

pub fn windowHint(hint: WindowHint, value: anytype) void {
    switch (hint) {
        .client_api => {
            std.debug.assert(@TypeOf(value) == API);
        },
        .context_creation_api => {
            std.debug.assert(@TypeOf(value) == ContextCreationAPI);
        },
        .context_robustness => {
            std.debug.assert(@TypeOf(value) == ContextRobustness);
        },
        .context_release_behaviour => {
            std.debug.assert(@TypeOf(value) == ReleaseBehaviour);
        },
        .opengl_profile => {
            std.debug.assert(@TypeOf(value) == OpenGLProfile);
        },
        .red_bits, .green_bits, .blue_bits, .alpha_bits, .depth_bits, .stencil_bits, .samples, .refresh_rate, .position_x, .position_y => {
            std.debug.assert(@TypeOf(value) == c_int);
        },
        else => {
            std.debug.assert(@TypeOf(value) == bool);
        },
    }

    switch (@typeInfo(@TypeOf(value))) {
        .Int => {
            c.glfwWindowHint(@intFromEnum(hint), @as(c_int, @intCast(value)));
        },
        .Bool => {
            c.glfwWindowHint(@intFromEnum(hint), @as(c_int, @intCast(@intFromBool(value))));
        },
        else => @compileError("expected a int or bool, got " ++ @typeName(@TypeOf(value))),
    }
}

pub inline fn windowDefaultHints() void {
    c.glfwDefaultWindowHints();
}

pub const JoystickCallbackFn = *const fn (i32, i32) callconv(.C) void;
pub inline fn setJoystickCallback(callback: ?JoystickCallbackFn) void {
    return c.glfwSetJoystickCallback(callback);
}

pub const MonitorCallbackFn = *const fn (?*Monitor, i32) callconv(.C) void;
pub inline fn setMonitorCallback(callback: ?MonitorCallbackFn) void {
    return c.glfwSetMonitorCallback(callback);
}

// Window API
pub const Window = extern struct {
    inner: *c.GLFWwindow = undefined,

    pub const to = PtrCast(Window).to;
    pub const from = PtrCast(Window).from;
    pub const toOptional = PtrCast(Window).toOptional;
    pub const fromOptional = PtrCast(Window).fromOptional;
};

pub fn createWindow(width: i32, height: i32, title: [:0]const u8, monitor: ?*Monitor, share: ?*Window) GLFWError!*Window {
    const window = c.glfwCreateWindow(width, height, title.ptr, Monitor.toOptional(monitor), Window.toOptional(share));
    if (window) |handle| {
        return Window.from(handle);
    }

    try err.any();

    return GLFWError.UnknownError;
}

pub inline fn destroyWindow(self: *Window) void {
    c.glfwDestroyWindow(self.to());
    self.inner = undefined;
}

pub inline fn windowShouldClose(self: *Window) bool {
    return c.glfwWindowShouldClose(self.to()) == c.GLFW_TRUE;
}

pub inline fn setWindowShouldClose(self: *Window, value: bool) void {
    c.glfwSetWindowShouldClose(self.to(), value);
}

pub inline fn swapBuffers(self: ?*Window) void {
    c.glfwSwapBuffers(Window.toOptional(self));
}

pub inline fn hideWindow(self: *Window) void {
    c.glfwHideWindow(self.to());
}

pub inline fn showWindow(self: *Window) void {
    c.glfwShowWindow(self.to());
}

pub inline fn focusWindow(self: *Window) void {
    c.glfwFocusWindow(self.to());
}

pub inline fn iconifyWindow(self: *Window) void {
    c.glfwIconifyWindow(self.to());
}

pub inline fn requestWindowAttention(self: *Window) void {
    c.glfwRequestWindowAttention(self.to());
}

pub inline fn setWindowUserPointer(self: *Window, pointer: *anyopaque) void {
    c.glfwSetWindowUserPointer(self.to(), pointer);
}

pub inline fn getWindowUserPointer(T: type, self: *Window) ?*T {
    if (c.glfwGetWindowUserPointer(self.to())) |user_pointer|
        return @as(?*T, @ptrCast(@alignCast(user_pointer)));
    return null;
}

pub inline fn setWindowSizeLimits(self: *Window, min_w: i32, min_h: i32, max_w: i32, max_h: i32) void {
    c.glfwSetWindowSizeLimits(self.to(), min_w, min_h, max_w, max_h);
}

pub inline fn setWindowAspectRatio(self: *Window, numerator: i32, denominator: i32) void {
    c.glfwSetWindowAspectRatio(self.to(), numerator, denominator);
}

pub inline fn setWindowPos(self: *Window, x: i32, y: i32) void {
    c.glfwSetWindowPos(self.to(), x, y);
}

pub inline fn setWindowIcon(self: *Window, count: i32, images: **c.GLFWimage) void {
    c.glfwSetWindowIcon(self.to(), count, images);
}

pub inline fn setWindowMonitor(self: *Window, monitor: ?*Monitor, xpos: i32, ypos: i32, width: i32, height: i32, refresh_rate: i32) void {
    c.glfwSetWindowMonitor(self.to(), Monitor.toOptional(monitor), xpos, ypos, width, height, refresh_rate);
}

pub inline fn setWindowOpacity(self: *Window, opacity: f32) void {
    c.glfwSetWindowOpacity(self.to(), opacity);
}

pub inline fn setWindowAttrib(self: *Window, attrib: Attribute, value: bool) void {
    c.glfwSetWindowAttrib(self.to(), attrib, @intCast(@intFromBool(value)));
}

pub inline fn setWindowTitle(self: *Window, title: [:0]const u8) void {
    c.glfwSetWindowTitle(self.to(), title.ptr);
}

pub const IconifyCallbackFn = *const fn (?*Window, i32) callconv(.C) void;
pub inline fn setWindowIconifyCallback(self: *Window, callback: ?IconifyCallbackFn) ?IconifyCallbackFn {
    return c.glfwSetWindowIconifyCallback(self.to(), callback);
}

pub const PositionCallbackFn = *const fn (?*Window, i32, i32) callconv(.C) void;
pub inline fn setWindowPosCallback(self: *Window, callback: ?PositionCallbackFn) ?PositionCallbackFn {
    return c.glfwSetWindowPosCallback(self.to(), callback);
}

pub const SizeCallbackFn = *const fn (?*Window, i32, c_int) callconv(.C) void;
pub inline fn setWindowSizeCallback(self: *Window, callback: ?SizeCallbackFn) ?SizeCallbackFn {
    return c.glfwSetWindowSizeCallback(self.to(), callback);
}

pub const CloseCallbackFn = *const fn (?*Window) callconv(.C) void;
pub inline fn setWindowCloseCallback(self: *Window, callback: ?CloseCallbackFn) ?CloseCallbackFn {
    return c.glfwSetWindowCloseCallback(self.to(), callback);
}

pub const RefreshCallbackFn = *const fn (?*Window) callconv(.C) void;
pub inline fn setWindowRefreshCallback(self: *Window, callback: ?RefreshCallbackFn) ?RefreshCallbackFn {
    return c.glfwSetWindowRefreshCallback(self.to(), callback);
}

pub const FocusCallbackFn = *const fn (?*Window, i32) callconv(.C) void;
pub inline fn setWindowFocusCallback(self: *Window, callback: ?FocusCallbackFn) ?FocusCallbackFn {
    return c.glfwSetWindowFocusCallback(self.to(), callback);
}

pub const MaximizeCallbackFn = *const fn (?*Window, i32) callconv(.C) void;
pub inline fn setWindowMaximizeCallback(self: *Window, callback: ?MaximizeCallbackFn) ?MaximizeCallbackFn {
    return c.glfwSetWindowMaximizeCallback(self.to(), callback);
}

pub const ContentScaleCallbackFn = *const fn (?*Window, f32, f32) callconv(.C) void;
pub inline fn setWindowContentScaleCallback(self: *Window, callback: ?ContentScaleCallbackFn) ?ContentScaleCallbackFn {
    return c.glfwSetWindowContentScaleCallback(self.to(), callback);
}

pub const KeyCallbackFn = *const fn (?*Window, Key, i32, Action, Mods) callconv(.C) void;
pub inline fn setKeyCallback(self: *Window, callback: ?KeyCallbackFn) ?KeyCallbackFn {
    return c.glfwSetKeyCallback(self.to(), callback);
}

pub const CharCallbackFn = *const fn (?*Window, u32) callconv(.C) void;
pub inline fn setCharCallback(self: *Window, callback: ?CharCallbackFn) ?CharCallbackFn {
    return c.glfwSetCharCallback(self.to(), callback);
}

pub const CharModsCallbackFn = *const fn (?*Window, u32, i32) callconv(.C) void;
pub inline fn setCharModsCallback(self: *Window, callback: ?CharModsCallbackFn) ?CharModsCallbackFn {
    return c.glfwSetCharModsCallback(self.to(), callback);
}

pub const MouseButtonCallbackFn = *const fn (?*Window, MouseButton, Action, Mods) callconv(.C) void;
pub inline fn setMouseButtonCallback(self: *Window, callback: ?MouseButtonCallbackFn) ?MouseButtonCallbackFn {
    return c.glfwSetMouseButtonCallback(self.to(), callback);
}

pub const CursorPosCallbackFn = *const fn (?*Window, f64, f64) callconv(.C) void;
pub inline fn setCursorPosCallback(self: *Window, callback: ?CursorPosCallbackFn) ?CursorPosCallbackFn {
    return c.glfwSetCursorPosCallback(self.to(), callback);
}

pub const CursorEnterCallbackFn = *const fn (?*Window, i32) callconv(.C) void;
pub inline fn setCursorEnterCallback(self: *Window, callback: ?CursorEnterCallbackFn) ?CursorEnterCallbackFn {
    return c.glfwSetCursorEnterCallback(self.to(), callback);
}

pub const ScrollCallbackFn = *const fn (?*Window, f64, f64) callconv(.C) void;
pub inline fn setScrollCallback(self: *Window, callback: ?ScrollCallbackFn) ?ScrollCallbackFn {
    return c.glfwSetScrollCallback(self.to(), callback);
}

pub const DropCallbackFn = *const fn (?*Window, i32, [*][*:0]const u8) callconv(.C) void;
pub inline fn setDropCallback(self: *Window, callback: ?DropCallbackFn) ?DropCallbackFn {
    return c.glfwSetDropCallback(self.to(), callback);
}

pub inline fn getWin32Window(self: *Window) ?std.os.windows.HWND {
    return c.glfwGetWin32Window(self.to());
}

pub inline fn getWaylandWindow(self: *Window) ?*anyopaque {
    return c.glfwGetWaylandWindow(self.to());
}

pub inline fn getX11Window(self: *Window) u32 {
    return c.glfwGetX11Window(self.to());
}

pub inline fn getCocoaWindow(self: *Window) ?*anyopaque {
    return c.glfwGetCocoaWindow(self.to());
}

pub inline fn vulkanSupported() bool {
    return c.glfwVulkanSupported() == c.GLFW_TRUE;
}

pub inline fn getRequiredInstanceExtensions() ?[][*:0]const u8 {
    var count: u32 = 0;
    if (c.glfwGetRequiredInstanceExtensions(&count)) |extensions| return @as([*][*:0]const u8, @ptrCast(extensions))[0..count];
    return null;
}

pub const VKProc = *const fn () callconv(if (builtin.os.tag == .windows and builtin.cpu.arch == .x86) .Stdcall else .C) void;
pub fn getInstanceProcAddress(vk_instance: ?*anyopaque, proc_name: [*:0]const u8) callconv(.C) ?VKProc {
    if (c.glfwGetInstanceProcAddress(if (vk_instance) |v| @as(c.VkInstance, @ptrCast(v)) else null, proc_name)) |proc_address| return proc_address;
    return null;
}

pub inline fn getPhysicalDevicePresentationSupport(
    vk_instance: *anyopaque,
    vk_physical_device: *anyopaque,
    queue_family: u32,
) bool {
    return c.glfwGetPhysicalDevicePresentationSupport(
        @as(c.VkInstance, @ptrCast(vk_instance)),
        @as(c.VkPhysicalDevice, @ptrCast(vk_physical_device)),
        queue_family,
    ) == c.GLFW_TRUE;
}

pub const VideoMode = extern struct {
    width: c_int = std.mem.zeroes(c_int),
    height: c_int = std.mem.zeroes(c_int),
    red_bits: c_int = std.mem.zeroes(c_int),
    green_bits: c_int = std.mem.zeroes(c_int),
    blue_bits: c_int = std.mem.zeroes(c_int),
    refresh_rate: c_int = std.mem.zeroes(c_int),

    pub const to = Cast(VideoMode, c.GLFWvidmode).to;
    pub const from = Cast(VideoMode, c.GLFWvidmode).from;
    pub const toOptional = Cast(VideoMode, c.GLFWvidmode).toOptional;
    pub const fromOptional = Cast(VideoMode, c.GLFWvidmode).fromOptional;
    pub const fromMultiple = Cast(VideoMode, c.GLFWvidmode).fromMultiple;
};

pub const Monitor = extern struct {
    inner: *c.GLFWmonitor = undefined,

    pub const to = PtrCast(Monitor).to;
    pub const from = PtrCast(Monitor).from;
    pub const toOptional = PtrCast(Monitor).toOptional;
    pub const fromOptional = PtrCast(Monitor).fromOptional;
};

pub fn getPrimaryMonitor() !*Monitor {
    if (c.glfwGetPrimaryMonitor()) |handle| {
        return Monitor.from(handle);
    }
    try err.any();
    return GLFWError.UnknownError;
}

pub fn getVideoMode(self: *Monitor) *VideoMode {
    return VideoMode.fromMultiple(c.glfwGetVideoMode(self.to()));
}

pub const PlatformHint = enum(c_int) {
    any_platform = c.GLFW_ANY_PLATFORM,
    win32 = c.GLFW_PLATFORM_WIN32,
    cocoa = c.GLFW_PLATFORM_COCOA,
    x11 = c.GLFW_PLATFORM_X11,
    wayland = c.GLFW_PLATFORM_WAYLAND,
    null = c.GLFW_PLATFORM_NULL,
};

pub const AnglePlatformType = enum(c_int) {
    none = c.GLFW_ANGLE_PLATFORM_TYPE_NONE,
    opengl = c.GLFW_ANGLE_PLATFORM_TYPE_OPENGL,
    opengles = c.GLFW_ANGLE_PLATFORM_TYPE_OPENGLES,
    d3d9 = c.GLFW_ANGLE_PLATFORM_TYPE_D3D9,
    d3d11 = c.GLFW_ANGLE_PLATFORM_TYPE_D3D11,
    vulkan = c.GLFW_ANGLE_PLATFORM_TYPE_VULKAN,
    metal = c.GLFW_ANGLE_PLATFORM_TYPE_METAL,
};

pub const WaylandLibDecor = enum(c_int) {
    prefer = c.GLFW_WAYLAND_PREFER_LIBDECOR,
    disable = c.GLFW_WAYLAND_DISABLE_LIBDECOR,
};

pub const InitHint = enum(c_int) {
    platform = c.GLFW_PLATFORM,
    joystick_hat_buttons = c.GLFW_JOYSTICK_HAT_BUTTONS,
    angle_platform_type = c.GLFW_ANGLE_PLATFORM_TYPE,
    cocoa_chdir_resources = c.GLFW_COCOA_CHDIR_RESOURCES,
    cocoa_menubar = c.GLFW_COCOA_MENUBAR,
    wayland_libdecor = c.GLFW_WAYLAND_LIBDECOR,
    x11_xcb_vulkan_surface = c.GLFW_X11_XCB_VK_SURFACE,
};

pub const API = enum(c_int) {
    none = c.GLFW_NO_API,
    opengl = c.GLFW_OPENGL_API,
    opengl_es = c.GLFW_OPENGL_ES_API,
};

pub const ContextCreationAPI = enum(c_int) {
    native = c.GLFW_NATIVE_CONTEXT_API,
    egl = c.GLFW_EGL_CONTEXT_API,
    osmesa = c.GLFW_OSMESA_CONTEXT_API,
};

pub const ContextRobustness = enum(c_int) {
    no_robustness = c.GLFW_NO_ROBUSTNESS,
    no_reset_notification = c.GLFW_NO_RESET_NOTIFICATION,
    lose_context_on_reset = c.GLFW_LOSE_CONTEXT_ON_RESET,
};

pub const ReleaseBehaviour = enum(c_int) {
    any = c.GLFW_ANY_RELEASE_BEHAVIOR,
    flush = c.GLFW_RELEASE_BEHAVIOR_FLUSH,
    none = c.GLFW_RELEASE_BEHAVIOR_NONE,
};

pub const OpenGLProfile = enum(c_int) {
    any = c.GLFW_OPENGL_ANY_PROFILE,
    core = c.GLFW_OPENGL_CORE_PROFILE,
    compat = c.GLFW_OPENGL_COMPAT_PROFILE,
};

pub const WindowHint = enum(c_int) {
    focused = c.GLFW_FOCUSED,
    iconified = c.GLFW_ICONIFIED,
    resizable = c.GLFW_RESIZABLE,
    visible = c.GLFW_VISIBLE,
    decorated = c.GLFW_DECORATED,
    auto_iconify = c.GLFW_AUTO_ICONIFY,
    floating = c.GLFW_FLOATING,
    maximized = c.GLFW_MAXIMIZED,
    center_cursor = c.GLFW_CENTER_CURSOR,
    transparent_framebuffer = c.GLFW_TRANSPARENT_FRAMEBUFFER,
    hovered = c.GLFW_HOVERED,
    focus_on_show = c.GLFW_FOCUS_ON_SHOW,
    mouse_passthrough = c.GLFW_MOUSE_PASSTHROUGH,
    position_x = c.GLFW_POSITION_X,
    position_y = c.GLFW_POSITION_Y,
    red_bits = c.GLFW_RED_BITS,
    green_bits = c.GLFW_GREEN_BITS,
    blue_bits = c.GLFW_BLUE_BITS,
    alpha_bits = c.GLFW_ALPHA_BITS,
    depth_bits = c.GLFW_DEPTH_BITS,
    stencil_bits = c.GLFW_STENCIL_BITS,
    stereo = c.GLFW_STEREO,
    samples = c.GLFW_SAMPLES,
    srgb_capable = c.GLFW_SRGB_CAPABLE,
    refresh_rate = c.GLFW_REFRESH_RATE,
    doublebuffer = c.GLFW_DOUBLEBUFFER,
    client_api = c.GLFW_CLIENT_API,
    context_version_major = c.GLFW_CONTEXT_VERSION_MAJOR,
    context_version_minor = c.GLFW_CONTEXT_VERSION_MINOR,
    context_revision = c.GLFW_CONTEXT_REVISION,
    context_robustness = c.GLFW_CONTEXT_ROBUSTNESS,
    opengl_forward_compat = c.GLFW_OPENGL_FORWARD_COMPAT,
    opengl_debug_context = c.GLFW_OPENGL_DEBUG_CONTEXT,
    opengl_profile = c.GLFW_OPENGL_PROFILE,
    context_release_behaviour = c.GLFW_CONTEXT_RELEASE_BEHAVIOR,
    context_no_error = c.GLFW_CONTEXT_NO_ERROR,
    context_creation_api = c.GLFW_CONTEXT_CREATION_API,
    scale_to_monitor = c.GLFW_SCALE_TO_MONITOR,
    scale_framebuffer = c.GLFW_SCALE_FRAMEBUFFER,
    cocoa_retina_framebuffer = c.GLFW_COCOA_RETINA_FRAMEBUFFER,
    cocoa_frame_name = c.GLFW_COCOA_FRAME_NAME,
    cocoa_graphics_switching = c.GLFW_COCOA_GRAPHICS_SWITCHING,
    x11_class_name = c.GLFW_X11_CLASS_NAME,
    x11_instance_name = c.GLFW_X11_INSTANCE_NAME,
    win32_keyboard_menu = c.GLFW_WIN32_KEYBOARD_MENU,
    win32_showdefault = c.GLFW_WIN32_SHOWDEFAULT,
    wayland_app_id = c.GLFW_WAYLAND_APP_ID,
};

pub const Attribute = enum(c_int) {
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

pub const Action = enum(c_int) {
    release,
    press,
    repeat,
};

pub const MouseButton = enum(c_int) {
    left,
    right,
    middle,
    four,
    five,
    six,
    seven,
    eight,
};

pub const Key = enum(c_int) {
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

pub const Mods = packed struct(c_int) {
    shift: bool = false,
    control: bool = false,
    alt: bool = false,
    super: bool = false,
    caps_lock: bool = false,
    num_lock: bool = false,
    _padding: i26 = 0,
};
