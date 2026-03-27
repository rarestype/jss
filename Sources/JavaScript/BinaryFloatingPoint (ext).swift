import JavaScriptBackend

extension BinaryFloatingPoint where Self: ConstructibleFromJSValue {
    @inlinable public static func load(from value: JSValue) throws -> Self {
        guard let value: Double = value.number else {
            throw JavaScriptTypecastError<Self>.diagnose(value)
        }
        return self.init(value)
    }
}
