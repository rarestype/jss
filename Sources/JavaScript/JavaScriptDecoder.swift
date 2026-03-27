import JavaScriptBackend

@frozen public struct JavaScriptDecoder<ObjectKey>: ~Copyable
    where ObjectKey: RawRepresentable<JSString> {

    @usableFromInline let object: JSObject

    @inlinable init(wrapping object: JSObject) {
        self.object = object
    }
}
extension JavaScriptDecoder<JavaScriptArrayKey> {
    @inlinable public init(array object: JSObject) throws {
        try object.assert(is: .Array)
        self.init(wrapping: object)
    }
}
extension JavaScriptDecoder {
    @inlinable public subscript(_ key: ObjectKey) -> Field {
        let key: JSString = key.rawValue
        return .init(id: key, value: self.object[key])
    }

    @inlinable public subscript(_ key: ObjectKey) -> Field? {
        let key: JSString = key.rawValue
        let value: JSValue = self.object[key]
        if  value.isUndefined || value.isNull {
            return nil
        } else {
            return .init(id: key, value: value)
        }
    }
}
extension JavaScriptDecoder<JavaScriptArrayKey> {
    @inlinable public subscript(_ index: Int) -> Position {
        return .init(index: index, value: self.object[index])
    }

    @inlinable public subscript(_ index: Int) -> Position? {
        let value: JSValue = self.object[index]
        if  value.isUndefined || value.isNull {
            return nil
        } else {
            return .init(index: index, value: value)
        }
    }
}
extension JavaScriptDecoder {
    @inlinable public func values<Value>(
        as _: Value.Type
    ) throws -> [ObjectKey: Value] where Value: LoadableFromJSValue {
        try self.values {
            [ObjectKey: Value].init(minimumCapacity: $0)
        } combine: {
            $0[$1] = $2
        }
    }

    #if WebAssembly
    @inlinable public func values<T, Value>(
        storage: (_ count: Int) throws -> T,
        combine: (inout T, ObjectKey, Value) throws -> (),
    ) throws -> T where Value: LoadableFromJSValue {
        guard
        let object: JSObject = JavaScriptClass.Object.constructor.keys?(
            self.object
        ).object else {
            fatalError("JavaScript Object.keys() did not return an object!")
        }
        let keys: JavaScriptDecoder<JavaScriptArrayKey> = try .init(array: object)
        let count: Int = try keys[.length].decode()
        return try (0 ..< count).reduce(into: try storage(count)) {
            guard let key: JSString = keys[$1].value.jsString else {
                return
            }
            guard let key: ObjectKey = .init(rawValue: key) else {
                throw KeyspaceError.init(invalid: key.description)
            }

            try combine(&$0, key, try self[key].decode())
        }
    }
    #else
    @inlinable public func values<T, Value>(
        storage: (_ count: Int) throws -> T,
        combine: (inout T, ObjectKey, Value) throws -> (),
    ) throws -> T where Value: LoadableFromJSValue {
        let properties: [String: JSValue] = self.object.properties
        return try properties.reduce(into: try storage(properties.count)) {
            let id: JSString = .init($1.key)
            guard let key: ObjectKey = .init(rawValue: id) else {
                throw KeyspaceError.init(invalid: $1.key)
            }

            let field: Field = .init(id: id, value: $1.value)
            try combine(&$0, key, try field.decode())
        }
    }
    #endif
}
