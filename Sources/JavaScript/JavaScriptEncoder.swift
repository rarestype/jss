import JavaScriptBackend

@frozen public struct JavaScriptEncoder<ObjectKey>: ~Copyable {
    @usableFromInline let object: JSObject

    @inlinable init(wrapping object: JSObject) {
        self.object = object
    }
}
extension JavaScriptEncoder where ObjectKey: RawRepresentable<JSString> {
    @inlinable public subscript<Value>(
        key: ObjectKey
    ) -> Value? where Value: ConvertibleToJSValue {
        get { nil }
        set (value) {
            if  let value: Value {
                self.object[key.rawValue] = value.jsValue
            }
        }
    }
}
extension JavaScriptEncoder<JavaScriptArrayKey> {
    @inlinable public subscript<Value>(index: Int) -> Value? where Value: ConvertibleToJSValue {
        get { nil }
        set (value) {
            if  let value: Value {
                self.object[index] = value.jsValue
            }
        }
    }

    @inlinable public mutating func push(_ value: some ConvertibleToJSValue) {
        #if WebAssembly
        _ = self.object.push?(value.jsValue)
        #else
        self.object.push(value.jsValue)
        #endif
    }
}
