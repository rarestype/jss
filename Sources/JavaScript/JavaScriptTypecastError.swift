import JavaScriptBackend

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
        if  let value: Bool = value.boolean {
            return .boolean(value)
        } else if let value: String = value.string {
            return .string(value)
        } else if let value: Double = value.number {
            return .number(value)
        } else if case _? = value.bigInt {
            return .bigint
        } else if case _? = value.symbol {
            return .symbol
        } else if case _? = value.object {
            return .object
        } else if value.isNull {
            return .null
        } else if value.isUndefined {
            return .undefined
        } else {
            fatalError("unknown JSValue type!?!?")
        }
    }
}
