import JavaScriptBackend

extension JavaScriptDecoder {
    @frozen public struct Field {
        @usableFromInline let id: JSString
        @usableFromInline let value: JSValue

        @inlinable init(id: JSString, value: JSValue) {
            self.id = id
            self.value = value
        }
    }
}
extension JavaScriptDecoder.Field {
    @inlinable public func decode<T>(
        to _: T.Type = T.self
    ) throws -> T where T: LoadableFromJSValue {
        do {
            return try T.load(from: self.value)
        } catch let error as JavaScriptDecodingStack {
            throw error.pushing(self.id)
        } catch let error {
            throw JavaScriptDecodingStack.init(problem: error, in: self.id)
        }
    }

    @inlinable public func decode<T, U>(
        as _: T.Type = T.self,
        with transform: (T) throws -> U
    ) throws -> U where T: LoadableFromJSValue {
        let representation: T = try self.decode()
        return try transform(representation)
    }
}
