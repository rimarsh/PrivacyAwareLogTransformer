//
//  PrivacyAwareLogTransformer.swift
//
//
//  Created by Riley Marsh on 12/22/19.
//

public protocol PrivacyAwareLogReceiver: AnyObject {
    func log(_ message: String, properties: [String: String]?, context: [AnyHashable: Any]?)
}

public struct PrivacyAwareLogTransformer {
    /// A delegate to receive transformed log messages and proeprties.
    public weak var receiver: PrivacyAwareLogReceiver?

    public init() { }

    /// Transforms and emits a log message to the reciever.
    ///
    /// - Parameter message: The message to be transformed and emitted.
    ///   Interpoated values in this message will be extracted into the properties dictionary
    /// - Parameter properties: An array of additional properties to be accociated
    ///   with the log message. Any duplicate keys in this dictionary will overwrite those
    ///   extracted from the message above.
    /// - Parameter context: An arbitrary dictionary for passing additional information
    ///   from the logging callsite to the reciever. For example, you could pass logging level
    ///   or file/line information.
    public func log(_ message: LoggableString, properties: [PrivacyAwareLoggable]? = nil, context: [AnyHashable: Any]? = nil) {
        if let properties = properties {
            var mergedProperties = message.properties ?? [String: String]()
            properties.forEach { mergedProperties[$0.loggingKey] = $0.loggingValue }
            receiver?.log(message.message, properties: mergedProperties, context: context)
        } else {
            receiver?.log(message.message, properties: message.properties, context: context)
        }
    }
}
