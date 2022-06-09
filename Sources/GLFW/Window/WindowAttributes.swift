import CGLFW3

@propertyWrapper
public struct WindowAttribute<Value: Int32Convertible> {
    @available(*, unavailable, message: "Attribute must only be used on class types")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    let attribute: Int32
    
    @MainActor public static subscript(_enclosingInstance instance: GLFWWindow, wrapped wrappedKeyPath: ReferenceWritableKeyPath<GLFWWindow, Value>, storage storageKeyPath: ReferenceWritableKeyPath<GLFWWindow, Self>) -> Value {
        get {
            Value(glfwGetWindowAttrib(instance.pointer, instance[keyPath: storageKeyPath].attribute))
        }
        set {
            glfwSetWindowAttrib(instance.pointer, instance[keyPath: storageKeyPath].attribute, newValue.int32)
        }
    }
    
    init(_ attribute: Int32) {
        self.attribute = attribute
    }
}

@propertyWrapper
public struct ContextAttribute<Value: Int32Convertible> {
    @available(*, unavailable, message: "Attribute must only be used on class types")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    let attribute: Int32
    
    @MainActor public static subscript(_enclosingInstance instance: GLFWContext, wrapped wrappedKeyPath: ReferenceWritableKeyPath<GLFWContext, Value>, storage storageKeyPath: ReferenceWritableKeyPath<GLFWContext, Self>) -> Value {
        get {
            Value(glfwGetWindowAttrib(instance.pointer, instance[keyPath: storageKeyPath].attribute))
        }
        set {
            glfwSetWindowAttrib(instance.pointer, instance[keyPath: storageKeyPath].attribute, newValue.int32)
        }
    }
    
    init(_ attribute: Int32) {
        self.attribute = attribute
    }
}
