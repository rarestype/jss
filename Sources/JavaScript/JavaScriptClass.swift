import JavaScriptBackend

@frozen @usableFromInline enum JavaScriptClass: JSString, Sendable {
    case Array
    case Object
    case URLSearchParams

    case Float16Array
    case Float32Array
    case Float64Array

    case Uint8Array
    case Uint16Array
    case Uint32Array
    case BigUint64Array

    case Int8Array
    case Int16Array
    case Int32Array
    case BigInt64Array
}

#if WebAssembly
extension JavaScriptClass {
    @inlinable var constructor: JSObject {
        JSObject.global[self.rawValue].function!
    }
}
#endif

extension JavaScriptClass: CustomStringConvertible {
    @inlinable var description: String { self.rawValue.description }
}
