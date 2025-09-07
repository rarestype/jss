import JavaScriptKit

extension LazyDropWhileSequence: ConvertibleToJSArray, @retroactive ConvertibleToJSValue
    where Element: ConvertibleToJSValue {
}
