// swift-tools-version:6.2
import PackageDescription
import typealias Foundation.ProcessInfo

let package: Package = .init(
    name: "jss",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "JavaScript", targets: ["JavaScript"]),
        .library(name: "JavaScriptExecution", targets: ["JavaScriptExecution"]),
    ],
    traits: [
        "Headless",
        "WebAssembly",
        .default(enabledTraits: ["WebAssembly"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/dollup", from: "1.0.2"),
        .package(url: "https://github.com/rarestype/swift-json", from: "2.3.2"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.50.1"),
    ],
    targets: [
        .target(
            name: "JavaScriptExecution",
            dependencies: [
                .target(name: "JavaScript"),
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]
        ),
        .target(
            name: "JavaScript",
            dependencies: [
                .target(name: "JavaScriptBackend"),
            ]
        ),
        .target(
            name: "JavaScriptBackend",
            dependencies: [
                .product(
                    name: "JavaScriptPersistence",
                    package: "swift-json",
                    condition: .when(traits: ["Headless"]),
                ),
                .product(
                    name: "JavaScriptBigIntSupport",
                    package: "JavaScriptKit",
                    condition: .when(traits: ["WebAssembly"]),
                ),
                .product(
                    name: "JavaScriptKit",
                    package: "JavaScriptKit",
                    condition: .when(traits: ["WebAssembly"]),
                ),
            ]
        ),
    ]
)

for target: Target in package.targets {
    if  case .plugin = target.type {
        continue
    }
    {
        var swift: [SwiftSetting] = $0 ?? []
        swift.append(.enableUpcomingFeature("ExistentialAny"))
        swift.append(.enableUpcomingFeature("InternalImportsByDefault"))
        $0 = swift
    } (&target.swiftSettings)
}
