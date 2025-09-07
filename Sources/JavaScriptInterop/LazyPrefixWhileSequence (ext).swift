import JavaScriptKit

extension LazyPrefixWhileSequence: ConvertibleToJSArray, @retroactive ConvertibleToJSValue
    where Element: ConvertibleToJSValue {
}
