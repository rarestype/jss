import JavaScriptKit

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

        switch self.object[key] {
        case .undefined:    return nil
        case .null:         return nil
        case let value:     return .init(id: key, value: value)
        }
    }
}
extension JavaScriptDecoder<JavaScriptArrayKey> {
    @inlinable public subscript(_ index: Int) -> Position {
        return .init(index: index, value: self.object[index])
    }

    @inlinable public subscript(_ index: Int) -> Position? {
        switch self.object[index] {
        case .undefined:    return nil
        case .null:         return nil
        case let value:     return .init(index: index, value: value)
        }
    }
}
extension JavaScriptDecoder {
    @inlinable public func values<Value>(
        as _: Value.Type
    ) throws -> [ObjectKey: Value] where Value: LoadableFromJSValue {
        guard
        case .object(let object)? = JavaScriptClass.Object.constructor.keys?(self.object) else {
            fatalError("JavaScript Object.keys() did not return an object!")
        }
        let keys: JavaScriptDecoder<JavaScriptArrayKey> = try .init(array: object)
        let count: Int = try keys[.length].decode()
        return try (0 ..< count).reduce(into: .init(minimumCapacity: count)) {
            guard case .string(let key) = keys[$1].value else {
                return
            }
            guard let key: ObjectKey = .init(rawValue: key) else {
                throw KeyspaceError.init(invalid: key.description)
            }

            $0[key] = try self[key].decode()
        }
    }
}
