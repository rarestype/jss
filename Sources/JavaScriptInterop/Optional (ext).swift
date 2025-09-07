import JavaScriptKit

extension Optional: LoadableFromJSValue where Wrapped: LoadableFromJSValue {
    @inlinable public static func load(from js: JSValue) throws -> Self {
        if case .null = js {
            return nil
        }
        return try Wrapped.load(from: js)
    }
}
