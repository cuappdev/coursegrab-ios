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

        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = Secrets.googleClientID
        GIDSignIn.sharedInstance()?.delegate = self

        // Set up networking
        Endpoint.setupEndpointConfig()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
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
