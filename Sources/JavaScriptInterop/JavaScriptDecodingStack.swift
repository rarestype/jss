import JavaScriptKit

@frozen public struct JavaScriptDecodingStack: Error {
    @usableFromInline let problem: any Error
    @usableFromInline var path: [Frame]

    @inlinable init(problem: any Error, in key: JSString) {
        self.problem = problem
        self.path = [.field(key.description)]
    }

    @inlinable init(problem: any Error, at index: Int) {
        self.problem = problem
        self.path = [.index(index)]
    }
}
extension JavaScriptDecodingStack {
    @inlinable consuming func pushing(_ field: JSString) -> Self {
        self.path.append(.field(field.description))
        return self
    }
    @inlinable consuming func pushing(_ index: Int) -> Self {
        self.path.append(.index(index))
        return self
    }
}
extension JavaScriptDecodingStack: CustomStringConvertible {
    public var description: String {
        var result: String = "Error: \(problem)"
        for frame in path {
            switch frame {
            case .field(let name):
                result += "\n  in field '\(name)'"
            case .index(let index):
                result += "\n  at index [\(index)]"
            }
        }
        return result
    }
}
