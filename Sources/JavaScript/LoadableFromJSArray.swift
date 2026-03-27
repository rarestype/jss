import JavaScriptBackend

public protocol LoadableFromJSArray: LoadableFromJSValue {
    static func load(from js: borrowing JavaScriptDecoder<JavaScriptArrayKey>) throws -> Self
}
extension LoadableFromJSArray {
    @inlinable public static func load(from js: JSValue) throws -> Self {
        guard let object: JSObject = js.object, object.is(.Array) else {
            throw JavaScriptTypecastError<Self>.diagnose(js)
        }

        let decoder: JavaScriptDecoder<JavaScriptArrayKey> = .init(wrapping: object)
        return try .load(from: decoder)
    }
}
extension LoadableFromJSArray
    where Self: RangeReplaceableCollection, Element: LoadableFromJSValue {
    @inlinable public static func load(
        from js: borrowing JavaScriptDecoder<JavaScriptArrayKey>
    ) throws -> Self {
        let count: Int = try js[.length].decode()
        var collection: Self = .init()
        ;   collection.reserveCapacity(count)

        for i: Int in 0 ..< count {
            collection.append(try js[i].decode())
        }

        return collection
    }
}
