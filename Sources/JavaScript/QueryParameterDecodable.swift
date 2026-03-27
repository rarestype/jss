import JavaScriptBackend

public protocol QueryParameterDecodable<QueryKey>: LoadableFromJSValue {
    associatedtype QueryKey: RawRepresentable<JSString>
    init(from js: borrowing QueryParameterDecoder<QueryKey>) throws
}
extension QueryParameterDecodable {
    @inlinable public static func load(from js: JSValue) throws -> Self {
        #if WebAssembly
        guard
        let object: JSObject = js.object, object.is(.URLSearchParams) else {
            throw JavaScriptTypecastError<Self>.diagnose(js)
        }

        let decoder: QueryParameterDecoder<QueryKey> = .init(wrapping: object)
        return try .init(from: decoder)
        #else
        throw JavaScriptTypecastError<Self>.diagnose(js)
        #endif
    }
}
