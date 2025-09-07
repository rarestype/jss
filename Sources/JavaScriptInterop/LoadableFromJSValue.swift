import JavaScriptKit

/// `LoadableFromJSValue` is a protocol that adds diagnostic traces to
/// ``ConstructibleFromJSValue``.
public protocol LoadableFromJSValue: ConstructibleFromJSValue {
    static func load(from js: JSValue) throws -> Self
}
extension LoadableFromJSValue {
    @inlinable public static func construct(from js: JSValue) -> Self? {
        try? .load(from: js)
    }
}
extension LoadableFromJSValue where Self: RawRepresentable,
    RawValue: ConstructibleFromJSValue {
    @inlinable public static func load(from js: JSValue) throws -> Self {
        guard
        let value: RawValue = .construct(from: js),
        let value: Self = .init(rawValue: value) else {
            throw JavaScriptTypecastError<RawValue>.diagnose(js)
        }
        return value
    }
}
