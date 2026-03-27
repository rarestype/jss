@frozen public struct JavaScriptDowncastError: Error {
    @usableFromInline let type: JavaScriptClass

    @inlinable init(type: JavaScriptClass) {
        self.type = type
    }
}
extension JavaScriptDowncastError: CustomStringConvertible {
    public var description: String {
        "JavaScript downcast error: expected instance of '\(self.type)'"
    }
}
