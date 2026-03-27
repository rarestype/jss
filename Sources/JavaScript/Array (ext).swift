// no need to conform Array to ConvertibleToJSArray as it already has the ConvertibleToJSValue
// witness from JavaScriptKit
extension Array: LoadableFromJSArray, LoadableFromJSValue where Element: LoadableFromJSValue {}
