import JavaScriptKit

extension Bool: LoadableFromJSValue {
    @inlinable public static func load(from value: JSValue) throws -> Self {
        guard case .boolean(let value) = value else {
            throw JavaScriptTypecastError<Bool>.diagnose(value)
        }
        return value
    }
}
