import JavaScriptKit

public protocol JavaScriptDecodable<ObjectKey>: LoadableFromJSValue {
    associatedtype ObjectKey: RawRepresentable<JSString>
    init(from js: borrowing JavaScriptDecoder<ObjectKey>) throws
}
extension JavaScriptDecodable {
    @inlinable public static func construct(from value: JSValue) -> Self? {
        guard case .object(let object) = value else {
            return nil
        }

        return try? .load(from: object)
    }

    @inlinable public static func load(from value: JSValue) throws -> Self {
        guard case .object(let object) = value else {
            throw JavaScriptTypecastError<JSObject>.diagnose(value)
        }

        return try .load(from: object)
    }

    @inlinable public static func load(from object: JSObject) throws -> Self {
        let decoder: JavaScriptDecoder<ObjectKey> = .init(wrapping: object)
        return try .init(from: decoder)
    }
}
