import JavaScriptBackend

extension JavaScriptDecoder {
    @frozen public struct Position {
        @usableFromInline let index: Int
        @usableFromInline let value: JSValue

        @inlinable init(index: Int, value: JSValue) {
            self.index = index
            self.value = value
        }
    }
}
extension JavaScriptDecoder.Position {
    @inlinable public func decode<T>(
        to _: T.Type = T.self
    ) throws -> T where T: LoadableFromJSValue {
        do {
            return try T.load(from: self.value)
        } catch let error as JavaScriptDecodingStack {
            throw error.pushing(self.index)
        } catch let error {
            throw JavaScriptDecodingStack.init(problem: error, at: self.index)
        }
    }
}
