//
//  PrivacyAwareLoggable.swift
//  
//
//  Created by Riley Marsh on 12/22/19.
//

import Foundation

/// Defines a loggable entitly.
///
/// Implementing this protocol defines how a given stuct or class should be
/// logged. Consumers should consider what should and should not be
/// in log files when implementing it.
public protocol PrivacyAwareLoggable {
    /// The key to be uses in emitted log messages.
    ///
    /// Note: This key should be static to the type and not comuted from
    /// its state otherwise it will not collate correctly with other instances
    /// of the same log.
    var loggingKey: String { get }

    /// The value to be emitted in logs as an attached dictionary. This value
    /// should be safe for logging and not a run-time determined value,
    /// such as responce from a service or error message.
    var loggingValue: String { get }
}

public extension PrivacyAwareLoggable {
    var loggingKey: String {
        // The default logging key is the implementing
        // object's name
        return String(describing: Self.self).lowercased()
    }
}
