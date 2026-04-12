@frozen @usableFromInline enum JavaScriptArgumentConventionError: Error {
    case missing(index: Int)
    case invalid(index: Int, problem: any Error)
}
extension JavaScriptArgumentConventionError: CustomStringConvertible {
    @usableFromInline var description: String {
        switch self {
        case .missing(let index):
            "Missing argument at index \(index)"
        case .invalid(let index, let problem):
            "Invalid argument at index \(index): \(problem)"
        }
    }
}
