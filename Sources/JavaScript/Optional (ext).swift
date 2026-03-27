import JavaScriptBackend

extension Optional: LoadableFromJSValue where Wrapped: LoadableFromJSValue {
    @inlinable public static func load(from js: JSValue) throws -> Self {
        js.isNull ? nil : try Wrapped.load(from: js)
    }
}
