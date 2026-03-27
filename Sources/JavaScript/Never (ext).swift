import JavaScriptBackend

extension Never: @retroactive ConvertibleToJSValue {
    @inlinable public var jsValue: JSValue { fatalError("unreachable") }
}
extension Never: @retroactive ConstructibleFromJSValue, LoadableFromJSValue {
    @inlinable public static func load(from js: JSValue) throws -> Self {
        throw JavaScriptTypecastError<Self>.diagnose(js)
    }
}
