import JavaScriptBackend

extension JSObject {
    #if WebAssembly

    @inlinable static func allocate(_ type: JavaScriptClass) -> JSObject {
        JSObject.global[type.rawValue].function!.new()
    }

    @inlinable func `is`(_ type: JavaScriptClass) -> Bool {
        self.isInstanceOf(JSObject.global[type.rawValue].function!)
    }

    #else

    @inlinable static func allocate(_ type: JavaScriptClass) -> JSObject {
        switch type {
        case .Array:
            return .array()
        case .Object:
            return .object()
        case .URLSearchParams:
            fatalError("URLSearchParams is not supported in this environment")
        }
    }

    @inlinable func `is`(_ type: JavaScriptClass) -> Bool {
        switch type {
        case .Array: self.isArray
        case .Object: true
        case .URLSearchParams: false
        }
    }

    #endif
}
extension JSObject {
    @inlinable func assert(is type: JavaScriptClass) throws {
        guard self.is(type) else {
            throw JavaScriptDowncastError.init(type: type)
        }
    }

    @inlinable public static func new<ObjectKey>(
        encoding encodable: some JavaScriptEncodable<ObjectKey>
    ) -> JSObject {
        let encoded: JSObject = .allocate(.Object)
        var encoder: JavaScriptEncoder<ObjectKey> = .init(wrapping: encoded)
        encodable.encode(to: &encoder)
        return encoded
    }

    @inlinable public static func new(
        encoding encodable: some ConvertibleToJSArray
    ) -> JSObject {
        let encoded: JSObject = .allocate(.Array)
        var encoder: JavaScriptEncoder<JavaScriptArrayKey> = .init(wrapping: encoded)
        encodable.encode(to: &encoder)
        return encoded
    }

    @inlinable public static func new<each Element>(
        array element: repeat each Element
    ) -> JSObject where repeat each Element: ConvertibleToJSValue {
        let encoded: JSObject = .allocate(.Array)
        var encoder: JavaScriptEncoder<JavaScriptArrayKey> = .init(wrapping: encoded)
        for element: _ in repeat each element {
            encoder.push(element)
        }
        return encoded
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
