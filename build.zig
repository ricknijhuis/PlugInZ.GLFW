const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const glfw_dep = b.dependency("glfw", .{});

    const glfw = b.addStaticLibrary(.{
        .name = "glfw",
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(glfw);

    glfw.addIncludePath(glfw_dep.path("include/GLFW"));
    glfw.linkLibC();

    switch (target.result.os.tag) {
        .windows => {
            glfw.linkSystemLibrary("gdi32");
            glfw.linkSystemLibrary("user32");
            glfw.linkSystemLibrary("shell32");
            glfw.addCSourceFiles(.{
                .root = glfw_dep.path("src"),
                .files = &.{
                    "platform.c",
                    "monitor.c",
                    "init.c",
                    "vulkan.c",
                    "input.c",
                    "context.c",
                    "window.c",
                    "osmesa_context.c",
                    "egl_context.c",
                    "null_init.c",
                    "null_monitor.c",
                    "null_window.c",
                    "null_joystick.c",
                    "wgl_context.c",
                    "win32_thread.c",
                    "win32_init.c",
                    "win32_monitor.c",
                    "win32_time.c",
                    "win32_joystick.c",
                    "win32_window.c",
                    "win32_module.c",
                },
                .flags = &.{"-D_GLFW_WIN32"},
            });
        },
        .macos => {
            @panic("MacOs support is not implemented yet");
            // if (b.lazyDependency("system_sdk", .{})) |system_sdk| {
            //     glfw.addFrameworkPath(system_sdk.path("macos12/System/Library/Frameworks"));
            //     glfw.addSystemIncludePath(system_sdk.path("macos12/usr/include"));
            //     glfw.addLibraryPath(system_sdk.path("macos12/usr/lib"));
            // }
            // glfw.linkSystemLibrary("objc");
            // glfw.linkFramework("IOKit");
            // glfw.linkFramework("CoreFoundation");
            // glfw.linkFramework("Metal");
            // glfw.linkFramework("AppKit");
            // glfw.linkFramework("CoreServices");
            // glfw.linkFramework("CoreGraphics");
            // glfw.linkFramework("Foundation");
            // glfw.addCSourceFiles(.{
            //     .root = glfw_dep.path("src"),
            //     .files = &.{
            //         "platform.c",
            //         "monitor.c",
            //         "init.c",
            //         "vulkan.c",
            //         "input.c",
            //         "context.c",
            //         "window.c",
            //         "osmesa_context.c",
            //         "egl_context.c",
            //         "null_init.c",
            //         "null_monitor.c",
            //         "null_window.c",
            //         "null_joystick.c",
            //         "posix_thread.c",
            //         "posix_module.c",
            //         "posix_poll.c",
            //         "nsgl_context.m",
            //         "cocoa_time.c",
            //         "cocoa_joystick.m",
            //         "cocoa_init.m",
            //         "cocoa_window.m",
            //         "cocoa_monitor.m",
            //     },
            //     .flags = &.{"-D_GLFW_COCOA"},
            // });
        },
        .linux => {
            @panic("Linux support is not implemented yet");
            //     if (b.lazyDependency("system_sdk", .{})) |system_sdk| {
            //         glfw.addSystemIncludePath(system_sdk.path("linux/include"));
            //         glfw.addSystemIncludePath(system_sdk.path("linux/include/wayland"));
            //         glfw.addIncludePath(b.path(src_dir ++ "wayland"));

            //         if (target.result.cpu.arch.isX86()) {
            //             glfw.addLibraryPath(system_sdk.path("linux/lib/x86_64-linux-gnu"));
            //         } else {
            //             glfw.addLibraryPath(system_sdk.path("linux/lib/aarch64-linux-gnu"));
            //         }
            //     }
            //     glfw.addCSourceFiles(.{
            //         .root = glfw_dep.path("src"),
            //         .files = &.{
            //             "platform.c",
            //             "monitor.c",
            //             "init.c",
            //             "vulkan.c",
            //             "input.c",
            //             "context.c",
            //             "window.c",
            //             "osmesa_context.c",
            //             "egl_context.c",
            //             "null_init.c",
            //             "null_monitor.c",
            //             "null_window.c",
            //             "null_joystick.c",
            //             "posix_time.c",
            //             "posix_thread.c",
            //             "posix_module.c",
            //             "egl_context.c",
            //         },
            //         .flags = &.{},
            //     });
            //     if (options.enable_x11 or options.enable_wayland) {
            //         glfw.addCSourceFiles(.{
            //             .root = glfw_dep.path("src"),
            //             .files = &.{
            //                 "xkb_unicode.c",
            //                 "linux_joystick.c",
            //                 "posix_poll.c",
            //             },
            //             .flags = &.{},
            //         });
            //     }
            //     if (options.enable_x11) {
            //         glfw.addCSourceFiles(.{
            //             .root = glfw_dep.path("src"),
            //             .files = &.{
            //                 "x11_init.c",
            //                 "x11_monitor.c",
            //                 "x11_window.c",
            //                 "glx_context.c",
            //             },
            //             .flags = &.{},
            //         });
            //         glfw.defineCMacro("_GLFW_X11", "1");
            //         glfw.linkSystemLibrary("X11");
            //     }
            //     if (options.enable_wayland) {
            //         glfw.addCSourceFiles(.{
            //             .root = glfw_dep.path("src"),
            //             .files = &.{
            //                 "wl_init.c",
            //                 "wl_monitor.c",
            //                 "wl_window.c",
            //             },
            //             .flags = &.{},
            //         });
            //         glfw.defineCMacro("_GLFW_WAYLAND", "1");
            //     }
        },
        else => {},
    }

    const glfw_module = b.addModule("glfw", .{
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path("src/root.zig"),
    });

    glfw_module.linkLibrary(glfw);
    glfw_module.addIncludePath(glfw_dep.path("include/GLFW"));
}
