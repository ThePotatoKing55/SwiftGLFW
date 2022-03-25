extension FixedWidthInteger {
    var normalized: Double {
        let min = Double(Self.min)
        let max = Double(Self.max)
        return (Double(self) - min) / (max - min)
    }
    
    init(normalizing normalized: Double) {
        let x = Swift.min(1, Swift.max(0, normalized))
        let min = Double(Self.min)
        let max = Double(Self.max)
        self = Self((max - min) * x + min)
    }
}

public struct Color: Hashable, Codable, Sendable, ExpressibleByIntegerLiteral {
    public var redBits, greenBits, blueBits: UInt8
    public var alphaBits: UInt8 = .max
    
    public var bitPattern: UInt32 {
        get { unsafeBitCast(self, to: UInt32.self) }
        set { self = unsafeBitCast(newValue, to: Color.self) }
    }
    
    public var red: Double {
        get { redBits.normalized }
        set { redBits = UInt8(normalizing: newValue) }
    }
    public var green: Double {
        get { greenBits.normalized }
        set { greenBits = UInt8(normalizing: newValue) }
    }
    public var blue: Double {
        get { blueBits.normalized }
        set { blueBits = UInt8(normalizing: newValue) }
    }
    public var alpha: Double {
        get { alphaBits.normalized }
        set { alphaBits = UInt8(normalizing: newValue) }
    }
    
    public init(bitPattern: UInt32) {
        self = unsafeBitCast(bitPattern, to: Color.self)
    }
    
    public init(integerLiteral value: UInt32) {
        self.init(bitPattern: value)
    }
}

extension Color {
    public init(rBits r: UInt8, g: UInt8, b: UInt8, a: UInt8 = .max) {
        self = unsafeBitCast((r, g, b, a), to: Color.self)
    }
    
    public init(whiteBits white: UInt8, alpha: UInt8 = .max) {
        self.init(rBits: white, g: white, b: white, a: alpha)
    }
    
    public init(r: Double, g: Double, b: Double, a: Double = 1) {
        self.init(rBits: .init(normalizing: r), g: .init(normalizing: g), b: .init(normalizing: b), a: .init(normalizing: a))
    }
    
    public init(white: Double, alpha: Double = 1) {
        let white = UInt8(normalizing: white)
        let alpha = UInt8(normalizing: alpha)
        self.init(rBits: white, g: white, b: white, a: alpha)
    }
}

extension Color {
    public var hsv: (h: Double, s: Double, v: Double) {
        get {
            var h = Double.zero
            var s = Double.zero
            
            let (r, g, b) = (red, green, blue)
            
            let cmin = min(r, g, b)
            let cmax = max(r, g, b)
            let delta = cmax - cmin
            if delta != 0 {
                if cmax == r {
                    h = (g - b) / delta
                } else if cmax == g {
                    h = 2 + (b - r) / delta
                } else {
                    h = 4 + (r - g) / delta
                }
                
                h += 1
                h /= 6
                s = delta/cmax
            }
            
            return (h, s, cmax)
        }
        set {
            self = Color(h: newValue.h, s: newValue.s, v: newValue.v, a: alpha)
        }
    }
    
    public init(h: Double, s: Double, v: Double, a: Double = 1) {
        let h = (h * 6).truncatingRemainder(dividingBy: 6)
        let c = v * s
        let x = c * (1 - (h.truncatingRemainder(dividingBy: 2) - 1).magnitude)
        let m = v - c
        
        var rgb: (Double, Double, Double)
        if h < 1 {
            rgb = (c, x, 0)
        } else if 1 <= h && h < 2 {
            rgb = (x, c, 0)
        } else if 2 <= h && h < 3 {
            rgb = (0, c, x)
        } else if 3 <= h && h < 4 {
            rgb = (0, x, c)
        } else if 4 <= h && h < 5 {
            rgb = (x, 0, c)
        } else {
            rgb = (c, 0, x)
        }
        
        let (r, g, b) = rgb
        self.init(r: r+m, g: g+m, b: b+m, a: a)
    }
    
    public var hsl: (h: Double, s: Double, l: Double) {
        get {
            var h = Double.zero
            var s = Double.zero
            
            let (r, g, b) = (red, green, blue)
            
            let cmin = min(r, g, b)
            let cmax = max(r, g, b)
            let delta = cmax - cmin
            if delta != 0 {
                if cmax == r {
                    h = (g - b) / delta
                } else if cmax == g {
                    h = 2 + (b - r) / delta
                } else {
                    h = 4 + (r - g) / delta
                }
                
                h += 1
                h /= 6
                s = delta/cmax
            }
            
            return (h, s, (cmax + cmin) * 0.5)
        }
        set {
            self = Color(h: newValue.h, s: newValue.s, l: newValue.l, a: alpha)
        }
    }
    
    public init(h: Double, s: Double, l: Double, a: Double = 1) {
        let h = (h * 6).truncatingRemainder(dividingBy: 6)
        let c = (1 - (2 * l - 1).magnitude) * s
        let x = c * (1 - (h.truncatingRemainder(dividingBy: 2) - 1).magnitude)
        let m = l - c/2
        
        var rgb: (Double, Double, Double)
        if h < 1 {
            rgb = (c, x, 0)
        } else if 1 <= h && h < 2 {
            rgb = (x, c, 0)
        } else if 2 <= h && h < 3 {
            rgb = (0, c, x)
        } else if 3 <= h && h < 4 {
            rgb = (0, x, c)
        } else if 4 <= h && h < 5 {
            rgb = (x, 0, c)
        } else {
            rgb = (c, 0, x)
        }
        
        let (r, g, b) = rgb
        self.init(r: r+m, g: g+m, b: b+m, a: a)
    }
}

extension Color {
    public var withPremultipliedAlpha: Self {
        return self * alpha
    }
    
    public func mixed(with other: Self) -> Self {
        let c1 = self.withPremultipliedAlpha
        let c2 = other.withPremultipliedAlpha
        let a2 = 1 - c2.alpha
        
        let r = c1.red * a2 + c2.red
        let g = c1.green * a2 + c2.green
        let b = c1.blue * a2 + c2.blue
        let a = c1.alpha * a2 + c2.alpha
        return Color(r: r, g: g, b: b, a: a)
    }
    
    public mutating func mix(with other: Self) {
        self = mixed(with: other)
    }
    
    public static let clear = Color(white: 0, alpha: 0)
    public static let white = Color(white: 1)
    public static let black = Color(white: 0)
    
    public static let red = Color(r: 1, g: 0, b: 0)
    public static let orange = Color(r: 1, g: 0.5, b: 0)
    public static let yellow = Color(r: 1, g: 1, b: 0)
    public static let green = Color(r: 0, g: 1, b: 0)
    public static let teal = Color(r: 0, g: 1, b: 0.5)
    public static let cyan = Color(r: 0, g: 1, b: 1)
    public static let sky = Color(r: 0, g: 0.5, b: 1)
    public static let blue = Color(r: 0, g: 0, b: 1)
    public static let purple = Color(r: 0.5, g: 0, b: 1)
    public static let magenta = Color(r: 1, g: 0, b: 1)
    public static let hotPink = Color(r: 1, g: 0, b: 0.5)
    
    public static let pink = Color(r: 1, g: 0.5, b: 0.75)
    
    public static func random(withAlphaBits a: UInt8 = .max) -> Color {
        Color(rBits: .random(in: .min ... .max), g: .random(in: .min ... .max), b: .random(in: .min ... .max), a: a)
    }
    public static func random<G: RandomNumberGenerator>(withAlphaBits a: UInt8 = .max, using generator: inout G) -> Color {
        Color(rBits: .random(in: .min ... .max, using: &generator), g: .random(in: .min ... .max, using: &generator), b: .random(in: .min ... .max, using: &generator), a: a)
    }
    public static func random(withAlpha a: Double) -> Color {
        Color(r: .random(in: 0...1), g: .random(in: 0...1), b: .random(in: 0...1), a: a)
    }
    public static func random<G: RandomNumberGenerator>(withAlpha a: Double, using generator: inout G) -> Color {
        Color(r: .random(in: 0...1, using: &generator), g: .random(in: 0...1, using: &generator), b: .random(in: 0...1, using: &generator), a: a)
    }
    
    public static func * (lhs: Self, rhs: Double) -> Self {
        Self(r: lhs.red * rhs, g: lhs.green * rhs, b: lhs.blue * rhs, a: lhs.alpha)
    }
}
