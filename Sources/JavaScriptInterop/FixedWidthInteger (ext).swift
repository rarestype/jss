import JavaScriptBigIntSupport
import JavaScriptKit

extension FixedWidthInteger where Self: SignedInteger & LoadableFromJSValue {
    @inlinable public static func load(from value: JSValue) throws -> Self {
        if  case .number(let number) = value,
            let number: Self = .init(exactly: number) {
            return number
        } else if
            case .bigInt(let number) = value,
            let number: Self = .init(exactly: number.int64Value) {
            return number
        } else {
            throw JavaScriptTypecastError<Self>.diagnose(value)
        }
    }
}
extension FixedWidthInteger where Self: UnsignedInteger & LoadableFromJSValue {
    @inlinable public static func load(from value: JSValue) throws -> Self {
        if  case .number(let number) = value,
            let number: Self = .init(exactly: number) {
            return number
        } else if
            case .bigInt(let number) = value,
            let number: Self = .init(exactly: number.uInt64Value) {
            return number
        } else {
            throw JavaScriptTypecastError<Self>.diagnose(value)
        }
    }
}
