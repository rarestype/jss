public import JavaScript

@frozen @usableFromInline struct JavaScriptPromiseResolvers {
    let success: ((any ConvertibleToJSValue...) -> JSValue)
    let failure: ((any ConvertibleToJSValue...) -> JSValue)
}
extension JavaScriptPromiseResolvers: JavaScriptDecodable {
    @frozen @usableFromInline enum ObjectKey: JSString, Sendable {
        case resolve
        case reject
    }

    @usableFromInline init(from js: borrowing JavaScriptDecoder<ObjectKey>) throws {
        self.init(success: try js[.resolve].witness, failure: try js[.reject].witness)
    }
}
