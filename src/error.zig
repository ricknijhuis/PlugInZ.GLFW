const c = @cImport({
    @cInclude("glfw3.h");
});

pub const GLFWError = error{
    NoError, // GLFW_NO_ERROR: No error has occurred.
    NotInitialized, // GLFW_NOT_INITIALIZED: GLFW has not been initialized.
    NoCurrentContext, // GLFW_NO_CURRENT_CONTEXT: No context is current for this thread.
    InvalidEnum, // GLFW_INVALID_ENUM: One of the arguments to the function was an invalid enum value.
    InvalidValue, // GLFW_INVALID_VALUE: One of the arguments to the function was an invalid value.
    OutOfMemory, // GLFW_OUT_OF_MEMORY: A memory allocation failed.
    ApiUnavailable, // GLFW_API_UNAVAILABLE: GLFW could not find support for the requested API on the system.
    VersionUnavailable, // GLFW_VERSION_UNAVAILABLE: The requested OpenGL or OpenGL ES version is not available.
    PlatformError, // GLFW_PLATFORM_ERROR: A platform-specific error occurred that does not match any specific categories.
    FormatUnavailable, // GLFW_FORMAT_UNAVAILABLE: The requested format is not supported or available.
    NoWindowContext, // GLFW_NO_WINDOW_CONTEXT: The specified window does not have an OpenGL or OpenGL ES context.
    CursorUnavailable, // GLFW_CURSOR_UNAVAILABLE: The specified cursor shape is not available.
    FeatureUnavailable, // GLFW_FEATURE_UNAVAILABLE: The requested feature is not provided by the platform.
    FeatureUnimplemented, // GLFW_FEATURE_UNIMPLEMENTED: The requested feature is not implemented for the platform.
    PlatformUnavailable, // GLFW_PLATFORM_UNAVAILABLE: Platform unavailable or no matching platform was found.
    UnknownError, // For undefined error codes
};

pub fn check(error_code: i32) GLFWError!void {
    return switch (error_code) {
        c.GLFW_NO_ERROR => {},
        c.GLFW_NOT_INITIALIZED => GLFWError.NotInitialized,
        c.GLFW_NO_CURRENT_CONTEXT => GLFWError.NoCurrentContext,
        c.GLFW_INVALID_ENUM => GLFWError.InvalidEnum,
        c.GLFW_INVALID_VALUE => GLFWError.InvalidValue,
        c.GLFW_OUT_OF_MEMORY => GLFWError.OutOfMemory,
        c.GLFW_API_UNAVAILABLE => GLFWError.ApiUnavailable,
        c.GLFW_VERSION_UNAVAILABLE => GLFWError.VersionUnavailable,
        c.GLFW_PLATFORM_ERROR => GLFWError.PlatformError,
        c.GLFW_FORMAT_UNAVAILABLE => GLFWError.FormatUnavailable,
        c.GLFW_NO_WINDOW_CONTEXT => GLFWError.NoWindowContext,
        c.GLFW_CURSOR_UNAVAILABLE => GLFWError.CursorUnavailable,
        c.GLFW_FEATURE_UNAVAILABLE => GLFWError.FeatureUnavailable,
        c.GLFW_FEATURE_UNIMPLEMENTED => GLFWError.FeatureUnimplemented,
        c.GLFW_PLATFORM_UNAVAILABLE => GLFWError.PlatformUnavailable,
        else => GLFWError.UnknownError, // For undefined error codes
    };
}

pub fn any() GLFWError!void {
    const error_code = c.glfwGetError(null);
    try check(error_code);
}
