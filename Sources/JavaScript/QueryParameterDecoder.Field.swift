import JavaScriptBackend

extension QueryParameterDecoder {
    @frozen public struct Field {
        @usableFromInline let id: JSString
        @usableFromInline let value: JSString?

        @inlinable init(id: JSString, value: JSString?) {
            self.id = id
            self.value = value
        }
    }
}
extension QueryParameterDecoder.Field {
    @inlinable public func decode<T>(
        to _: T.Type = T.self
    ) throws -> T where T: LosslessStringConvertible {
        guard
        let string: String = self.value?.description else {
            throw QueryParameterMissingError.init(id: self.id.description)
        }
        guard let value: T = .init(string) else {
            throw QueryParameterDecodingError<T>.init(id: self.id.description, string: string)
        }

        return value
    }
}
