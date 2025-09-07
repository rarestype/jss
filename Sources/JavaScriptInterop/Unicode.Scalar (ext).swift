import JavaScriptKit

extension Unicode.Scalar: LoadableFromJSString, ConvertibleToJSString,
    @retroactive ConstructibleFromJSValue,
    @retroactive ConvertibleToJSValue {
}
