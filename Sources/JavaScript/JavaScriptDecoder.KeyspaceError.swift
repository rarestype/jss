extension JavaScriptDecoder {
    @frozen public struct KeyspaceError: Error {
        public let invalid: String

        @inlinable init(invalid: String) {
            self.invalid = invalid
        }
    }
}
extension JavaScriptDecoder.KeyspaceError: CustomStringConvertible {
    public var description: String {
        """
        Object key '\(self.invalid)' is not a valid case of \
        '\(String.init(reflecting: ObjectKey.self))'
        """
    }
}
