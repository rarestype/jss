import JavaScriptKit

extension ConvertibleToJSValue where Self: RawRepresentable, RawValue: ConvertibleToJSValue {
    @inlinable public var jsValue: JSValue { self.rawValue.jsValue }
}
