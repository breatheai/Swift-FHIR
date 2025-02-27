// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Package.swift
//  SwiftFHIR
//
//  Created by Pascal Pfiffner on 12/10/15.
//  Modified by Dave Carlson on 8/6/2019.
//

import PackageDescription

let package = Package(
	name: "FHIR",
	platforms: [
		.macOS(.v15),
        .iOS(.v12)
	],
    products: [
        .library(
            name: "FHIR",
            targets: ["FHIR"]),
    ],
    targets: [
		.target(
			name: "FHIR",
			dependencies: ["Models", "Client"]),
		.target(
			name: "Models",
			dependencies: []),
		.target(
			name: "Client",
			dependencies: ["Models"]),
        .testTarget(
            name: "ClientTests",
            dependencies: ["Client"]),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Models"]),

		// Test targets not supported until Swift Packages include resource bundles.
    ],
    swiftLanguageModes: [.version("5.10"), .version("6")]
)
