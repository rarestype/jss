import JavaScriptBackend

extension JSValue: LoadableFromJSValue {
    @inlinable public static func load(from js: JSValue) -> Self { js }
}
