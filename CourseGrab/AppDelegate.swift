//
//  AppDelegate.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnnouncements
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

        // Setup AppDevAnnouncements
        AnnouncementNetworking.setupConfig(
            scheme: Secrets.announcementsScheme,
            host: Secrets.announcementsHost,
            commonPath: Secrets.announcementsCommonPath,
            announcementPath: Secrets.announcementsPath
        )
        
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
    
    /**
     Notifications flow:
      1. Device receives notification
        - If received when app is open: present banner
        - If received when app is closed: OS handles presenting banner
      2. User taps notification
        - App opens/moves to foreground
        - Navigation controller pushes a `NotificationModalViewController`
        - All notifications already delivered are deleted, badge number set to 0
      3. User opens app without tapping on notification
        - All notifications already delivered are deleted, badge number set to 0
     */
    
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
    
    // Called when the user taps the notification to open the app whether or not the app
    // was in the foreground, in the background, or terminated
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        AppDevAnalytics.shared.logFirebase(NotificationPressPayload())
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            handleNotification(userInfo: userInfo)
        }
        completionHandler()
    }
    
    // Called when the user receives a notification while the app is open
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        AppDevAnalytics.shared.logFirebase(NotificationPressPayload())
        completionHandler([.alert, .badge, .sound])
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func handleNotification(userInfo: [String: Any]) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = Endpoint.config.keyDecodingStrategy
        guard let aps = userInfo["aps"] as? [String : Any],
            let alert = aps["alert"],
            let data = try? JSONSerialization.data(withJSONObject: alert, options: []),
            let payload = try? decoder.decode(APNPayload.self, from: data)
            else { return }

        APNNotificationCenter.default.notify(payload: payload)
    }
    
}
