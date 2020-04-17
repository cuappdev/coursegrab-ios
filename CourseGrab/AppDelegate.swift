//
//  AppDelegate.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Firebase
import FirebaseAuth
import FutureNova
import GoogleSignIn
import UIKit
import UserNotifications

import NotificationCenter
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Setup firebase
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = Secrets.googleClientID
        GIDSignIn.sharedInstance()?.delegate = self

        // Setup networking
        Endpoint.setupEndpointConfig()
        
        // Setup push notifications
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
}

// MARK: - GIDSignInDelegate

extension AppDelegate: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (result, error) in
            User.current?.googleToken = authentication.idToken
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
}

// MARK: - UNUserNotificationCenterDelegate + notification registration

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        NetworkManager.shared.sendDeviceToken(deviceToken: token).observe { result in
            switch result {
            case .value:
                break
            case .error(let error):
                print(error)
            }
        }
    }
    
    // Called when ther user tapped the notification to open the app
    // whether or not the app was terminated or in the background
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            handleNotification(userInfo: userInfo)
        }
        completionHandler()
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    
    // Called when the user received a notification while the app is open
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String: Any] {
            handleNotification(userInfo: userInfo)
        }
    }
    
    private func handleNotification(userInfo: [String: Any]) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = Endpoint.config.keyDecodingStrategy
        guard let aps = userInfo["aps"] as? [String : Any],
            let alert = aps["alert"] as? String,
            let payload = try? decoder.decode(APNPayload.self, from: Data(alert.utf8))
            else { return }

        APNNotificationCenter.default.notify(payload: payload)
    }
    
}
