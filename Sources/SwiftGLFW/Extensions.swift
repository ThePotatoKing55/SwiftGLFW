import Foundation
import CGLFW3

extension Int32: ExpressibleByBooleanLiteral {
    var bool: Bool {
        self == Constant.true
    }
    var int: Int {
        Int(self)
    }
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value.int32)
    }
}

extension BinaryInteger {
    var int: Int {
        Int(self)
    }
    
    var int32: Int32 {
        Int32(self)
    }
}

extension Int {
    var int32: Int32 {
        Int32(self)
    }
}

extension UInt32 {
    var bool: Bool {
        self == Constant.true
    }
    var int: Int {
        Int(self)
    }
}

extension UInt {
    var int32: UInt32 {
        UInt32(self)
    }
}

extension Bool {
    var int32: Int32 {
        self ? Constant.true : Constant.false
    }
}
