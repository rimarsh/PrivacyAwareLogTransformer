@testable import PrivacyAwareLogTransformer
import XCTest

final class PrivacyAwareLogTransformerTests: XCTestCase {
    var logger = PrivacyAwareLogTransformer()
    var receiver = LoggingReceiver()

    override func setUp() {
        super.setUp()
        logger.receiver = receiver
    }

    func testLog() {
        logger.log("a plain message")
        XCTAssertEqual("a plain message", receiver.lastLogMessage)
        XCTAssertNil(receiver.lastProperties)
    }

    func testLogWithInterpolation() {
        let user = User(userId: UUID(), name: "Bob")
        logger.log("a user is \(user)")
        XCTAssertEqual("a user is {{user_1}}", receiver.lastLogMessage)
        XCTAssertEqual(["user_1": user.userId.uuidString], receiver.lastProperties)
    }

    func testLogWithInterpolationHandlesMultipleOfSameType() {
        let user1 = User(userId: UUID(), name: "Bob")
        let user2 = User(userId: UUID(), name: "Joe")
        logger.log("the users are \(user1) and \(user2)")
        XCTAssertEqual("the users are {{user_1}} and {{user_2}}", receiver.lastLogMessage)
        let expected = ["user_1": user1.userId.uuidString,
                        "user_2": user2.userId.uuidString]
        XCTAssertEqual(expected, receiver.lastProperties)

        let user3 = User(userId: UUID(), name: "John")
        logger.log("the users are \(user1), \(user2), and \(user3)")
        XCTAssertEqual("the users are {{user_1}}, {{user_2}}, and {{user_3}}", receiver.lastLogMessage)
        let expected2 = ["user_1": user1.userId.uuidString,
                         "user_2": user2.userId.uuidString,
                         "user_3": user3.userId.uuidString]
        XCTAssertEqual(expected2, receiver.lastProperties)
    }

    func testLogWithInterpolationHandlesMultipleOfSameTypeAndDifferentTypes() {
        let user1 = User(userId: UUID(), name: "Bob")
        let user2 = User(userId: UUID(), name: "Joe")
        let group = Group(groupId: UUID(), name: "Team")
        logger.log("the users are \(user1) and \(user2) in \(group)")
        XCTAssertEqual("the users are {{user_1}} and {{user_2}} in {{group_1}}", receiver.lastLogMessage)
        let expected = ["user_1": user1.userId.uuidString,
                        "user_2": user2.userId.uuidString,
                        "group_1": group.groupId.uuidString]
        XCTAssertEqual(expected, receiver.lastProperties)
    }

    func testLogWithInterpolationAndProperties() {
        let user = User(userId: UUID(), name: "Bob")
        let group = Group(groupId: UUID(), name: "Team")
        logger.log("a user is \(user)", properties: [group])
        XCTAssertEqual("a user is {{user_1}}", receiver.lastLogMessage)
        let expected = ["user_1": user.userId.uuidString,
                        "group": group.groupId.uuidString]
        XCTAssertEqual(expected, receiver.lastProperties)
    }

    func testLogFromInterpolatedStringProperty() {
        let user = User(userId: UUID(), name: "Bob")
        let message: LoggableString = "a user is \(user)"
        logger.log(message)
        XCTAssertEqual("a user is {{user_1}}", receiver.lastLogMessage)
        let expected = ["user_1": user.userId.uuidString]
        XCTAssertEqual(expected, receiver.lastProperties)
    }

    static var allTests = [
        ("testLog", testLog),
        ("testLogWithInterpolation", testLogWithInterpolation),
        ("testLogWithInterpolationHandlesMultipleOfSameType",
         testLogWithInterpolationHandlesMultipleOfSameType),
        ("testLogWithInterpolationHandlesMultipleOfSameTypeAndDifferentTypes",
         testLogWithInterpolationHandlesMultipleOfSameTypeAndDifferentTypes),
        ("testLogWithInterpolationAndProperties", testLogWithInterpolationAndProperties),
        ("testLogFromInterpolatedStringProperty", testLogFromInterpolatedStringProperty)
    ]
}
