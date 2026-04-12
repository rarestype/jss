@frozen public enum JavaScriptWitnessError: Error {
    case missing
}
extension JavaScriptWitnessError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .missing: "missing witness table entry"
        }
    }
}
