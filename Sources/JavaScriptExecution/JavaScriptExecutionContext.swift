#if canImport(JavaScriptEventLoop)
public import JavaScript
public import JavaScriptEventLoop

@frozen public struct JavaScriptExecutionContext {
    private let metatype: JSObject
    private let bind: JavaScriptPromiseResolvers
}
extension JavaScriptExecutionContext {
    @MainActor public static func setup(
        workers: Int = 2,
        with yield: @escaping (
            _ context: consuming Self,
            _ instance: consuming JSObject,
            _ executor: WebWorkerTaskExecutor
        ) async throws -> ()
    ) {
        JavaScriptEventLoop.installGlobalExecutor()

        let _: Task<(), Never> = .init {
            guard
            let instance: JSObject = JSObject.global["swift"].object,
            let metatype: JSObject = instance.constructor.function else {
                fatalError("missing handle for 'window.swift'")
            }

            let exit: JavaScriptPromiseResolvers
            do {
                exit = try .load(from: instance.exit)
            } catch let error {
                fatalError("could not load resolver for 'window.swift.exit': \(error)")
            }

            let executor: WebWorkerTaskExecutor
            do {
                executor = try await .init(numberOfThreads: workers)
            } catch let error {
                fatalError("could not create WebWorkerTaskExecutor: \(error)")
            }

            defer {
                executor.terminate()
            }

            do {
                let api: Self = .init(metatype: metatype, bind: try .load(from: instance.bind))
                try await yield(api, instance, executor)
                _ = exit.success()
            } catch let error {
                print("Fatal error in main: \(error)")
                _ = exit.failure()
            }
        }
    }
}
extension JavaScriptExecutionContext {
    public func bind<Symbol, E>(
        names _: Symbol.Type = Symbol.self,
        _ yield: (borrowing JavaScriptModule<Symbol>) throws(E) -> ()
    ) throws(E) where Symbol: Identifiable<String> {
        do {
            try yield(JavaScriptModule<Symbol>.init(metatype: self.metatype))
            _ = self.bind.success()
        } catch let error {
            _ = self.bind.failure()
            throw error
        }
    }
}
#endif
