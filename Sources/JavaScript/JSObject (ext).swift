import JavaScriptBackend

extension JSObject {
    @inlinable static func allocate(_ type: JavaScriptClass) -> JSObject {
        #if WebAssembly
        JSObject.global[type.rawValue].function!.new()
        #else
        switch type {
        case .Array:
            return .array()
        case .Object:
            return .object()
        case .URLSearchParams:
            fatalError("URLSearchParams is not supported in this environment")
        }
        #endif
    }

    @inlinable static func allocate<ObjectKey>(
        _ type: JavaScriptClass,
        _: ObjectKey.Type = ObjectKey.self,
        with encode: (inout JavaScriptEncoder<ObjectKey>) -> ()
    ) -> JSObject {
        let encoded: JSObject = .allocate(type)
        var encoder: JavaScriptEncoder<ObjectKey> = .init(wrapping: encoded)
        encode(&encoder)
        return encoded
    }

    @inlinable func `is`(_ type: JavaScriptClass) -> Bool {
        #if WebAssembly
        self.isInstanceOf(JSObject.global[type.rawValue].function!)
        #else
        switch type {
        case .Array: self.isArray
        case .Object: true
        case .URLSearchParams: false
        }
        #endif
    }
}
extension JSObject {
    @inlinable func assert(is type: JavaScriptClass) throws {
        guard self.is(type) else {
            throw JavaScriptDowncastError.init(type: type)
        }
    }

    @inlinable public static func new<ObjectKey>(
        _: ObjectKey.Type = ObjectKey.self,
        with encode: (inout JavaScriptEncoder<ObjectKey>) -> ()
    ) -> JSObject {
        .allocate(.Object, with: encode)
    }

    @inlinable public static func new<ObjectKey>(
        encoding encodable: some JavaScriptEncodable<ObjectKey>
    ) -> JSObject {
        .allocate(.Object) { encodable.encode(to: &$0) }
    }

    @inlinable public static func new(
        encoding encodable: some ConvertibleToJSArray
    ) -> JSObject {
        .allocate(.Array) { encodable.encode(to: &$0) }
    }

    @inlinable public static func new<each Element>(
        array element: repeat each Element
    ) -> JSObject where repeat each Element: ConvertibleToJSValue {
        .allocate(.Array) {
            for element: _ in repeat each element {
                $0.push(element)
            }
        }
    }
}
extension JSObject: LoadableFromJSValue {
    /// Note that this will **not** work for subclasses of ``JSObject``.
    @inlinable public static func load(
        from js: JSValue
    ) throws -> Self {
        guard let object: Self = Self.construct(from: js) else {
            throw JavaScriptTypecastError<Self>.diagnose(js)
        }
        return object
    }
}
