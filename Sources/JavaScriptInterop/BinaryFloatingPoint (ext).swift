import JavaScriptKit

extension BinaryFloatingPoint where Self: ConstructibleFromJSValue {
    @inlinable public static func load(from value: JSValue) throws -> Self {
        guard case .number(let value) = value else {
            throw JavaScriptTypecastError<Self>.diagnose(value)
        }
        return self.init(value)
    }
}
