import Foundation
import PrivacyAwareLogTransformer

class LoggingReceiver: PrivacyAwareLogReceiver {
    var lastLogMessage: String?
    var lastProperties: [String: String]?

    func log(_ message: String, properties: [String: String]?, context: [AnyHashable: Any]?) {
        lastLogMessage = message
        lastProperties = properties
    }
}

struct User: PrivacyAwareLoggable {
    let userId: UUID
    let name: String

    var loggingValue: String {
        return userId.uuidString
    }
}

struct Group: PrivacyAwareLoggable {
    let groupId: UUID
    let name: String

    var loggingValue: String {
        return groupId.uuidString
    }
}

struct Network {
    let networkId: UUID
    let name: String
}
