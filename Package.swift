// swift-tools-version:6.1
import PackageDescription
import typealias Foundation.ProcessInfo

let package: Package = .init(
    name: "jss",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .visionOS(.v2), .watchOS(.v11)],
    products: [
        .library(name: "JavaScriptInterop", targets: ["JavaScriptInterop"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.33.1"),
    ],
    targets: [
        .target(
            name: "JavaScriptInterop",
            dependencies: [
                .product(name: "JavaScriptBigIntSupport", package: "JavaScriptKit"),
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
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
