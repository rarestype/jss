#if WebAssembly
import JavaScriptBackend

extension JSTypedArray<UInt8> {
    public convenience init?(object: JSObject) {
        let Uint8Array: JSObject = JavaScriptClass.Uint8Array.constructor
        if  object.isInstanceOf(Uint8Array) {
            self.init(unsafelyWrapping: object)
        } else {
            // Wrap ArrayBuffers, JS Arrays, or other TypedArray views into a Uint8Array
            self.init(unsafelyWrapping: Uint8Array.new(object))
        }
    }
}
#endif
