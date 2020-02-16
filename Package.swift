// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "PrivacyAwareLogTransformer",
    products: [
        .library(
            name: "PrivacyAwareLogTransformer",
            targets: ["PrivacyAwareLogTransformer"])
    ],
    targets: [
        .target(name: "PrivacyAwareLogTransformer"),
        .testTarget(
            name: "PrivacyAwareLogTransformerTests",
            dependencies: ["PrivacyAwareLogTransformer"],
            exclude: ["BuildFailureTests.swift"]
        )
    ]
)
