import JavaScriptBackend

public protocol ConvertibleToJSString: ConvertibleToJSValue {
}
extension ConvertibleToJSString where Self: CustomStringConvertible {
    @inlinable public var jsValue: JSValue {
        .string(JSString.init(self.description))
    }
}
