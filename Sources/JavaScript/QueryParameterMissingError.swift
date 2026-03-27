@frozen @usableFromInline struct QueryParameterMissingError: Error {
    @usableFromInline let id: String
    @inlinable init(id: String) {
        self.id = id
    }
}
extension QueryParameterMissingError: CustomStringConvertible {
    public var description: String {
        "missing query parameter value for key '\(self.id)'"
    }
}
