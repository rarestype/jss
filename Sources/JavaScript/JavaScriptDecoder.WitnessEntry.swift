import JavaScriptBackend

extension JavaScriptDecoder {
    @frozen public struct WitnessEntry<Value> {
        @usableFromInline let id: JSString
        @usableFromInline let value: Value

        @inlinable init(id: JSString, value: Value) {
            self.id = id
            self.value = value
        }
    }
}
extension JavaScriptDecoder.WitnessEntry<((any ConvertibleToJSValue...) -> JSValue)> {
    @inlinable public var witness: ((any ConvertibleToJSValue...) -> JSValue) { self.value }
}
extension JavaScriptDecoder.WitnessEntry<((any ConvertibleToJSValue...) -> JSValue)?> {
    @inlinable public var witness: ((any ConvertibleToJSValue...) -> JSValue) {
        get throws(JavaScriptWitnessError) {
            guard let value: ((any ConvertibleToJSValue...) -> JSValue) = self.value else {
                throw .missing
            }
            return value
        }
    }
}
