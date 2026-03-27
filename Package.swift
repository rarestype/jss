// swift-tools-version:6.2
import PackageDescription
import typealias Foundation.ProcessInfo

let package: Package = .init(
    name: "jss",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "JavaScript", targets: ["JavaScript"]),
    ],
    traits: [
        "Headless",
        "WebAssembly",
        .default(enabledTraits: ["WebAssembly"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/dollup", from: "1.0.1"),
        .package(url: "https://github.com/rarestype/swift-json", from: "2.3.2"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.48.0"),
    ],
    targets: [
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
    let swift: [SwiftSetting]
    let c: [CSetting]

    switch ProcessInfo.processInfo.environment["SWIFT_TESTABLE"]
    {
    case "1"?, "true"?:
        swift = [
            .enableUpcomingFeature("ExistentialAny"),
            .define("TESTABLE")
        ]

    case "0"?, "false"?, nil:
        swift = [
            .enableUpcomingFeature("ExistentialAny"),
        ]

    case let value?:
        fatalError("Unexpected 'SWIFT_TESTABLE' value: \(value)")
    }

    switch ProcessInfo.processInfo.environment["SWIFT_WASM_SIMD128"]
    {
    case "1"?, "true"?:
        c = [
            .unsafeFlags(["-msimd128"])
        ]

    case "0"?, "false"?, nil:
        c = [
        ]

    case let value?:
        fatalError("Unexpected 'SWIFT_WASM_SIMD128' value: \(value)")
    }

    {
        $0 = ($0 ?? []) + swift
    } (&target.swiftSettings)

    if case .macro = target.type {
        // Macros are not compiled with C settings.
        continue
    }

    {
        $0 = ($0 ?? []) + c
    } (&target.cSettings)
}
