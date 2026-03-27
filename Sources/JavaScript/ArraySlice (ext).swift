extension ArraySlice: ConvertibleToJSArray, @retroactive ConvertibleToJSValue
    where Element: ConvertibleToJSValue {
}
extension ArraySlice: LoadableFromJSArray, LoadableFromJSValue,
    @retroactive ConstructibleFromJSValue where Element: LoadableFromJSValue {}
