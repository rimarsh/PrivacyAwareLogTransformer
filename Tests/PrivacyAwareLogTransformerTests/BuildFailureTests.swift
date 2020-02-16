@testable import PrivacyAwareLogTransformer
import XCTest

final class BuildFailureTests: XCTestCase {
    var logger = PrivacyAwareLogTransformer()
    var receiver = LoggingReceiver()

    override func setUp() {
        super.setUp()
        logger.receiver = receiver
    }

    func testWontBuild() {
        // It is a compilation error to log a non-safe type
        let network = Network(networkId: UUID(), name: "Acme")
        logger.debug("cannot log \(network)")

        // This includes generic properties within a safe type
        let user = User(userId: UUID(), name: "Bob")
        logger.debug("also cannot log strings \(user.name)")

        // This shows that even initializing a LoggableString doesn't work
        let userName: String = "name: \(user.name)"
        let message = LoggableString(stringLiteral: userName)
        logger.debug(message)
    }
}
