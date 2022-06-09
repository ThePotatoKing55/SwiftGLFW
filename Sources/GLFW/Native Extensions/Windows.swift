#if os(Windows)
extension GLFWWindow {
    public func setIcon(_ icon: Image) {
        var icon = icon.glfwImage
        glfwSetWindowIcon(pointer, 1, &icon)
    }
    
    public func resetIcon() {
        glfwSetWindowIcon(pointer, 0, nil)
    }
}
#endif
