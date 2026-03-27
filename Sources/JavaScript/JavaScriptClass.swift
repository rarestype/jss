import JavaScriptBackend

@frozen @usableFromInline enum JavaScriptClass: JSString, Sendable {
    case Array
    case Object
    case URLSearchParams
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
