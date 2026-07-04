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
    /// Register an async callback that always runs on the `@MainActor`. If JavaScript code
    /// calls it from a Web Worker, it will have to hop threads to run on the main actor, which
    /// could be slow. However, it is efficient for JavaScript callers from the main thread, and
    /// permits the passage of non-Sendable parameter types (such as ``JSObject``) to
    /// asynchronous functions, as it is known that the callback will not leave the region where
    /// the non-Sendable parameter is valid for.
    @inlinable public subscript<each T, U>(
        symbol: Symbol
    ) -> @MainActor (repeat each T) async throws -> U
        where repeat each T: LoadableFromJSValue,
        U: ConvertibleToJSValue & SendableMetatype {
        get {
            { (_: repeat each T) in fatalError("no implementation provided") }
        }
        nonmutating set(yield) {
            self.register(as: symbol) { (argument: repeat each T) -> JSValue in
                try await yield(repeat each argument).jsValue
            }
        }
    }

    @inlinable public subscript<each T>(
        symbol: Symbol
    ) -> @MainActor (repeat each T) async throws -> ()
        where repeat each T: LoadableFromJSValue {
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

    @inlinable func register<each T>(
        as symbol: Symbol,
        operation: @MainActor @escaping (repeat each T) async throws -> JSValue
    ) where repeat each T: LoadableFromJSValue {
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

@MainActor extension JavaScriptModule {
    /// Register an async callback that always runs in the same region as the caller. If
    /// JavaScript code calls it from a Web Worker, it will run on the worker thread. However,
    /// the parameter types and the return type must be Sendable. The Swift compiler is not
    /// currently able to prove statically that a non-Sendable value would not leave the region
    /// where it is valid for.
    @inlinable public subscript<each T, U>(
        nonisolated symbol: Symbol
    ) -> (repeat each T) async throws -> sending U
        where repeat each T: LoadableFromJSValue & Sendable,
        U: ConvertibleToJSValue & SendableMetatype {
        get {
            { (_: repeat each T) in fatalError("no implementation provided") }
        }
        nonmutating set(yield) {
            self.register(nonisolated: symbol) { (argument: repeat each T) -> sending JSValue in
                try await yield(repeat each argument).jsValue
            }
        }
    }

    @inlinable public subscript<each T>(
        nonisolated symbol: Symbol
    ) -> (repeat each T) async throws -> ()
        where repeat each T: LoadableFromJSValue & Sendable {
        get {
            { (_: repeat each T) in fatalError("no implementation provided") }
        }
        nonmutating set(yield) {
            self.register(nonisolated: symbol) { (argument: repeat each T) in
                try await yield(repeat each argument)
                return .undefined
            }
        }
    }

    @inlinable func register<each T>(
        nonisolated symbol: Symbol,
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
