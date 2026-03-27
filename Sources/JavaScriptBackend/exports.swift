#if WebAssembly
@_exported import JavaScriptBigIntSupport
@_exported import JavaScriptKit
#elseif Headless
@_exported import JavaScriptPersistence
#else
#error("One of 'WebAssembly' or 'Headless' traits must be defined")
#endif
