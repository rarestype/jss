<div align="center">

🥖 &nbsp; **jss** &nbsp; 🥖

A lightweight, serialization-free bridge for passing data between Swift and JavaScript in WebAssembly applications.

[documentation](https://swiftinit.org/docs/jss) ·
[license](LICENSE)

</div>


## Requirements

The jss library requires Swift 6.2 or later.

<!-- DO NOT EDIT BELOW! AUTOSYNC CONTENT [STATUS TABLE] -->
| Platform | Status |
| -------- | ------ |
| 💬 Documentation | [![Status](https://raw.githubusercontent.com/rarestype/jss/refs/badges/ci/Documentation/_all/status.svg)](https://github.com/rarestype/jss/actions/workflows/Documentation.yml) |
|  | [![Status](https://raw.githubusercontent.com/rarestype/jss/refs/badges/ci/Documentation/Linux/status.svg)](https://github.com/rarestype/jss/actions/workflows/Documentation.yml) |
|  | [![Status](https://raw.githubusercontent.com/rarestype/jss/refs/badges/ci/Documentation/macOS/status.svg)](https://github.com/rarestype/jss/actions/workflows/Documentation.yml) |
| 🐧 Linux | [![Status](https://raw.githubusercontent.com/rarestype/jss/refs/badges/ci/Tests/Linux/status.svg)](https://github.com/rarestype/jss/actions/workflows/Tests.yml) |
| 🍏 Darwin | [![Status](https://raw.githubusercontent.com/rarestype/jss/refs/badges/ci/Tests/macOS/status.svg)](https://github.com/rarestype/jss/actions/workflows/Tests.yml) |
<!-- DO NOT EDIT ABOVE! AUTOSYNC CONTENT [STATUS TABLE] -->


## Why this library?

When you compile Swift to WebAssembly, you’re essentially running Swift code in a sandboxed environment within the browser.
This environment doesn’t have direct access to the browser's DOM (Document Object Model) or other JavaScript APIs.
To interact with the web page, you need a way to pass data and call functions between Swift and JavaScript.

A common approach is to serialize data into a format like JSON, pass it as a string, and then deserialize it on the other side. However, this has some drawbacks:

*Performance overhead*: Serialization and deserialization can be slow, especially for large or complex data structures.

*Boilerplate code*: JSON is only a subset of JavaScript, which means you often need to write additional, parallel decoding and encoding logic to handle types (such as `BigInt`) that cannot be represented in JSON.

*Loss of type safety*: You’re essentially passing strings back and forth, which means you lose the benefits of Swift’s strong type system at the boundary between the two languages.


## Direct object access without serialization

The JavaScriptKit-based abstractions in this library solve these problems by providing a way to directly access and manipulate JavaScript objects from Swift, and vice versa, without ever serializing the data. This is achieved through a set of protocols and generic types that create a powerful and flexible binding layer.

Here are the key components and how they work together:


### `JavaScriptEncodable` and `JavaScriptDecodable`

These are the two main protocols that you'll conform your Swift types to.

-   `JavaScriptEncodable` allows you to “encode” a Swift object into a JavaScript object.
-   `JavaScriptDecodable` allows you to “decode” a JavaScript object into a Swift object.

### `JavaScriptEncoder` and `JavaScriptDecoder`

These are the workhorses that do the actual encoding and decoding.

-   `JavaScriptEncoder` takes a Swift object and, by using key-value pairs that you define in your Swift code, it populates a new JavaScript object. The keys are typically defined in an enum with `JSString` raw values, which provides a typesafe way to refer to the JavaScript object’s properties.

-   `JavaScriptDecoder` does the reverse. It wraps a `JSObject` and allows you to access its properties using the same `JSString`-backed enum to decode the values into a new Swift object.

### `LoadableFromJSValue` and `ConvertibleToJSValue`

These are lower-level protocols that provide the basic machinery for converting between Swift and JavaScript types. Many of the basic Swift types (like String, Int, Double, etc.) are already extended to conform to these protocols.

The `LoadableFromJSValue` and `ConvertibleToJSValue` are generally used with `RawRepresentable` types that have `RawValue` types that already conform to these protocols.

In situations where you want to use a type’s `LosslessStringConvertible` representation, use the `LoadableFromJSString` and `ConvertibleToJSString` protocols instead.


## Example usage

Here’s a quick example of how to make a Swift struct compatible with the JavaScript binding layer.

First, define your Swift struct:

```swift
struct Cell {
    let id: HexCoordinate
    let type: String
    let tile: PlanetTile
}
```

Next, create an enum that defines the keys for the JavaScript object’s properties. This enum should be backed by `JSString`:

```swift
extension Cell {
    enum ObjectKey: JSString {
        case id
        case type
        case tile
    }
}
```

Now, conform your Cell struct to `JavaScriptEncodable` and `JavaScriptDecodable`:

```swift
extension Cell: JavaScriptEncodable {
    func encode(to js: inout JavaScriptEncoder<ObjectKey>) {
        js[.id] = self.id
        js[.type] = self.type
        js[.tile] = self.tile
    }
}

extension Cell: JavaScriptDecodable {
    init(from js: borrowing JavaScriptDecoder<ObjectKey>) throws {
        self.init(
            id: try js[.id].decode(),
            type: try js[.type].decode(),
            tile: try js[.tile]?.decode() ?? .init(),
        )
    }
}
```

With these conformances, you can now seamlessly pass `Cell` instances between your Swift and JavaScript code.
