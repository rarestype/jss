import JavaScriptKit

extension Character: LoadableFromJSString, ConvertibleToJSString,
    @retroactive ConstructibleFromJSValue,
    @retroactive ConvertibleToJSValue {
}
