import JavaScriptKit

extension Array: LoadableFromJSArray, LoadableFromJSValue where Element: LoadableFromJSValue {
    @inlinable public static func load(
        from js: borrowing JavaScriptDecoder<JavaScriptArrayKey>
    ) throws -> Self {
        let count: Int = try js[.length].decode()
        var array: [Element] = []
        array.reserveCapacity(count)

        for i: Int in 0 ..< count {
            array.append(try js[i].decode())
        }

        return array
    }
}
