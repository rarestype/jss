import JavaScriptKit

/// This is safe, because in WebAssembly, `UInt` is 32 bits long.
extension UInt: LoadableFromJSValue {}
