import JavaScriptKit

public protocol LoadableFromJSString: LoadableFromJSValue {
    static func parse(from js: JSString) throws -> Self
}
extension LoadableFromJSString {
    @inlinable public static func load(from js: JSValue) throws -> Self {
        guard case .string(let value) = js else {
            throw JavaScriptTypecastError<JSString>.diagnose(js)
        }
        return try .parse(from: value)
    }
}
extension LoadableFromJSString where Self: LosslessStringConvertible {
    @inlinable public static func parse(from js: JSString) throws -> Self {
        let string: String = js.description
        guard let value: Self = .init(string) else {
            throw JavaScriptTypecastError<Self>.string(string)
        }
        return value
    }
}
