public import JavaScript

@frozen @usableFromInline struct JavaScriptArguments {
    @usableFromInline let list: [JSValue]
    @usableFromInline var index: Int

    @inlinable init(list: [JSValue]) {
        self.list = list
        self.index = list.startIndex
    }
}
extension JavaScriptArguments {
    @inlinable mutating func next<T>(
        as _: T.Type = T.self
    ) throws -> T where T: LoadableFromJSValue {
        guard self.index < list.endIndex else {
            throw JavaScriptArgumentConventionError.missing(index: index)
        }
        defer { index += 1 }
        do {
            return try .load(from: list[index])
        } catch let error {
            throw JavaScriptArgumentConventionError.invalid(index: index, problem: error)
        }
    }
}
