import JavaScriptKit

public protocol ConvertibleToJSArray: ConvertibleToJSValue {
    func encode(to js: inout JavaScriptEncoder<JavaScriptArrayKey>)
}
extension ConvertibleToJSArray {
    @inlinable public var jsValue: JSValue {
        .object(.new(encoding: self))
    }
}
extension ConvertibleToJSArray where Self: Sequence, Element: ConvertibleToJSValue {
    @inlinable public func encode(to js: inout JavaScriptEncoder<JavaScriptArrayKey>) {
        for element: Element in self {
            js.push(element)
        }
    }
}
