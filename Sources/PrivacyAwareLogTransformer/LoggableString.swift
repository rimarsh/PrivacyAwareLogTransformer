//
//  LoggableString.swift
//  
//
//  Created by Riley Marsh on 12/22/19.
//

import Foundation

public struct LoggableString: ExpressibleByStringInterpolation {
    public struct StringInterpolation: StringInterpolationProtocol {
        var output = String()
        var keyCounts = [String: Int]()
        var properties = [String: String]()

        public init(literalCapacity: Int, interpolationCount: Int) { }

        public mutating func appendLiteral(_ literal: StaticString) {
            output.append(literal.stringValue)
        }

        public mutating func appendInterpolation(_ value: PrivacyAwareLoggable) {
            let baseKeyString = value.loggingKey
            let newKeyCount = (keyCounts[baseKeyString] ?? 0) + 1
            let keyString = "\(baseKeyString)_\(newKeyCount)"
            output.append(keyString.asReplacement)
            properties[keyString] = value.loggingValue
            keyCounts[baseKeyString] = newKeyCount
        }
    }

    // Using an internal type of StaticString allows us to prevent
    // initialization with an already interpolated `String` type.
    private let staticValue: StaticString
    private let interpolatedValue: String?

    /// The transformed log message with interpoated values replaced by a placeholder.
    var message: String {
        return interpolatedValue ?? staticValue.stringValue
    }

    /// A dictionary of the replaced values by their placeholder keys.
    let properties: [String: String]?

    public init(stringLiteral value: StaticString) {
        self.staticValue = value
        self.interpolatedValue = nil
        self.properties = nil
    }

    public init(stringInterpolation: StringInterpolation) {
        self.staticValue = ""
        self.interpolatedValue = stringInterpolation.output
        self.properties = stringInterpolation.properties
    }
}

fileprivate extension String {
    var asReplacement: String {
        return "{{\(self)}}"
    }
}

fileprivate extension StaticString {
    var stringValue: String {
        return withUTF8Buffer {
            String(decoding: $0, as: UTF8.self)
        }
    }
}
