#if canImport(JavaScriptEventLoop)
public import JavaScript
internal import JavaScriptKit

@frozen public struct JavaScriptModule<Symbol>: ~Copyable where Symbol: Identifiable<String> {
    @usableFromInline let metatype: JSObject
}
extension JavaScriptModule {
    @inlinable public subscript<each T>(
        symbol: Symbol
    ) -> (repeat each T) throws -> () where repeat each T: LoadableFromJSValue {
        get {
            { (_: repeat each T) in fatalError("no implementation provided") }
        }
        nonmutating set(yield) {
            self.register(as: symbol) { (argument: repeat each T) in
                try yield(repeat each argument)
                return .undefined
            }
        }
    }

    @inlinable public subscript<each T, U>(
        symbol: Symbol
    ) -> (repeat each T) throws -> U where repeat each T: LoadableFromJSValue,
        U: ConvertibleToJSValue {
        get {
            { (_: repeat each T) in fatalError("no implementation provided") }
        }
        nonmutating set(yield) {
            self.register(as: symbol) { (argument: repeat each T) in
                try yield(repeat each argument).jsValue
            }
        }
    }

    @inlinable func register<each T>(
        as symbol: Symbol,
        operation: @escaping (repeat each T) throws -> JSValue
    ) where repeat each T: LoadableFromJSValue {
        self.metatype[symbol.id] = .object(
            JSClosure.init {
                do {
                    var arguments: JavaScriptArguments = .init(list: $0)
                    return try operation(
                        repeat try arguments.next(as: (each T).self)
                    )
                } catch let error {
                    print("Error in '\(symbol.id)': \(error)")
                    dump(error)
                    //let error: JSObject = JSError.constructor!.new("\(error)")
                    return .undefined
                }
            }
        )
    }
}
@MainActor extension JavaScriptModule {
    @inlinable public subscript<each T>(
        symbol: Symbol
    ) -> (repeat each T) async throws -> ()
        where repeat each T: LoadableFromJSValue & Sendable {
        get {
            { (_: repeat each T) in fatalError("no implementation provided") }
        }
        nonmutating set(yield) {
            self.register(as: symbol) { (argument: repeat each T) in
                try await yield(repeat each argument)
                return .undefined
            }
        }
    }
    @inlinable public subscript<each T, U>(
        symbol: Symbol
    ) -> (repeat each T) async throws -> sending U
        where repeat each T: LoadableFromJSValue & Sendable,
        U: ConvertibleToJSValue & SendableMetatype {
        get {
            { (_: repeat each T) in fatalError("no implementation provided") }
        }
        nonmutating set(yield) {
            self.register(as: symbol) { (argument: repeat each T) -> sending JSValue in
                try await yield(repeat each argument).jsValue
            }
        }
    }

    @inlinable func register<each T>(
        as symbol: Symbol,
        operation: sending @escaping (repeat each T) async throws -> sending JSValue
    ) where repeat each T: LoadableFromJSValue & Sendable {
        self.metatype[symbol.id] = .object(
            JSClosure.async {
                var arguments: JavaScriptArguments = .init(list: $0)
                do {
                    return try await operation(
                        repeat try arguments.next(as: (each T).self)
                    )
                } catch let error {
                    print("Error in '\(symbol.id)': \(error)")
                    dump(error)
                    //let error: JSObject = JSError.constructor!.new("\(error)")
                    return .undefined
                }
            }
        )
    }
}
#endif
