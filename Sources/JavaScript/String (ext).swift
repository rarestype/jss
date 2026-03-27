import JavaScriptBackend

extension String: LoadableFromJSValue {
    @inlinable public static func load(from value: JSValue) throws -> Self {
        guard let value: String = value.string else {
            throw JavaScriptTypecastError<Self>.diagnose(value)
        }
        return value
    }
}
