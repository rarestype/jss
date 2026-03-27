import JavaScriptBackend

extension Bool: LoadableFromJSValue {
    @inlinable public static func load(from value: JSValue) throws -> Self {
        guard let value: Bool = value.boolean else {
            throw JavaScriptTypecastError<Bool>.diagnose(value)
        }
        return value
    }
}
