import JavaScriptKit

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
        to _:T.Type = T.self
    ) throws -> T where T: LoadableFromJSValue {
        do {
            return try T.load(from: self.value)
        } catch let error as JavaScriptDecodingStack {
            throw error.pushing(self.id)
        } catch let error {
            throw JavaScriptDecodingStack.init(problem: error, in: self.id)
        }
    }
}
