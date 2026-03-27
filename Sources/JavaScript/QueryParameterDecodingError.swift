@frozen @usableFromInline struct QueryParameterDecodingError<T>: Error {
    @usableFromInline let id: String
    @usableFromInline let string: String
    @inlinable init(id: String, string: String) {
        self.id = id
        self.string = string
    }
}
extension QueryParameterDecodingError: CustomStringConvertible {
    public var description: String {
        """
        failed to decode value '\(self.string)' for query parameter '\(self.id)' \
        to expected type '\(String.init(reflecting: T.self))'
        """
    }
}
