import JavaScriptBackend

public protocol JavaScriptEncodable<ObjectKey>: ConvertibleToJSValue {
    associatedtype ObjectKey: RawRepresentable<JSString>
    func encode(to js: inout JavaScriptEncoder<ObjectKey>)
}
extension JavaScriptEncodable {
    @inlinable public var jsValue: JSValue {
        .object(.new(encoding: self))
    }
}
