//
//  AppDelegate.swift
//  iOS Example
//
//  Created by Riley Marsh on 12/31/19.
//  Copyright © 2019 Riley Marsh. All rights reserved.
//

import UIKit
import PrivacyAwareLogTransformer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private static let receiver = LogReceiver()
    private static let logger: PrivacyAwareLogTransformer = {
        var logger = PrivacyAwareLogTransformer()
        logger.receiver = receiver
        return logger
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Self.logger.log("a basic message")
        Self.logger.log("a message with an object: \(User(name: "Bob"))")
        // The line below won't compile since the object doesn't implement PrivacyAwareLoggable
        // Self.logger.log("a message with an object: \(Team(name: "My Team"))")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

struct User: PrivacyAwareLoggable {
    let userId: UUID = UUID()
    let name: String

    var loggingValue: String {
        return userId.uuidString
    }
}

struct Team {
    let team: UUID = UUID()
    let name: String
}

class LogReceiver: PrivacyAwareLogReceiver {

    func log(_ message: String, properties: [String : String]?, context: [AnyHashable : Any]?) {
        print("message: \(message), properties: \(properties ?? [:]), context: \(context ?? [:])")
    }

}
