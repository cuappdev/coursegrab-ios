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
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        // Check if user tapped on a notification
        if let userInfo = launchOptions?[.remoteNotification] as? [String: Any] {
            handleNotification(userInfo: userInfo) // TODO: FINISH
        }
        
        // Check all delivered notifications
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            // TODO: FINISH
        }

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

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Received a notification while the app is open
        // TODO: open notification modal depending on payload
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

// MARK: - APNNotificationCenter

class APNNotificationCenter {
    
    typealias Listener = (APNPayload) -> ()
    
    static let `default` = APNNotificationCenter()
    
    private init() { }
    
    private var listeners: [Listener] = []
    private var payloads: [APNPayload] = []
    
    /// Adds a listener and notifies the listener of any prior notifications
    func addListener(listener: @escaping Listener) {
        listeners.append(listener)
        // Notify the listener of any payloads they might have missed
        for payload in payloads {
            listener(payload)
        }
    }
    
    /// Notifies all listeners of the payload
    func notify(payload: APNPayload) {
        for listener in listeners {
            listener(payload)
        }
    }
    
}
