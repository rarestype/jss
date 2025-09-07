import JavaScriptKit

public enum JavaScriptTypecastError<T>: Error {
    case boolean(Bool)
    case string(String)
    case number(Double)
    case object
    case null
    case undefined
    case function
    case symbol
    case bigint
}
extension JavaScriptTypecastError {
    /// The payloads of ``JSValue``’s cases are not ``Sendable``, so if we want to capture
    /// diagnostic traces, we need to load them into Swift types.
    @inlinable static func diagnose(_ value: JSValue) -> Self {
        switch value {
        case .boolean(let value): .boolean(value)
        case .string(let value): .string(value.description)
        case .number(let value): .number(value)
        case .object(_): .object
        case .null: .null
        case .undefined: .undefined
        case .function(_): .function
        case .symbol(_): .symbol
        case .bigInt(_): .bigint
        }
    }
}
