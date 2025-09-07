import JavaScriptKit

public protocol LoadableFromJSArray: LoadableFromJSValue {
    static func load(from js: borrowing JavaScriptDecoder<JavaScriptArrayKey>) throws -> Self
}
extension LoadableFromJSArray {
    @inlinable public static func load(from js: JSValue) throws -> Self {
        guard
        case .object(let object) = js, object.is(.Array) else {
            throw JavaScriptTypecastError<Self>.diagnose(js)
        }

        let decoder: JavaScriptDecoder<JavaScriptArrayKey> = .init(wrapping: object)
        return try .load(from: decoder)
    }
}
