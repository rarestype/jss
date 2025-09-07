import JavaScriptKit

extension String: LoadableFromJSValue {
    @inlinable public static func load(from value: JSValue) throws -> Self {
        guard case .string(let value) = value else {
            throw JavaScriptTypecastError<Self>.diagnose(value)
        }
        return value.description
    }
}
