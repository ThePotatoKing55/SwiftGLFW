public enum ButtonState: Int {
    case released, pressed, held
    init(_ rawValue: Int) {
        self = Self(rawValue: rawValue) ?? .released
    }
}
