import JavaScriptKit


extension JSObject {
    @inlinable static func allocate(_ type: JavaScriptClass) -> JSObject {
        JSObject.global[type.rawValue].function!.new()
    }

    @inlinable func `is`(_ type: JavaScriptClass) -> Bool {
        self.isInstanceOf(JSObject.global[type.rawValue].function!)
    }

    @inlinable func assert(is type: JavaScriptClass) throws {
        guard self.is(type) else {
            throw JavaScriptDowncastError.init(type: type)
        }
    }
}
extension JSObject {
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
