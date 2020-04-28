//
//  SceneDelegate.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import FirebaseAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: scene)
        let splash = UIViewController()
        splash.view.backgroundColor = .white
        window.rootViewController = splash

        Auth.auth().addStateDidChangeListener { (auth, user) in
            // Register user for notifications
            if user != nil {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }

            // Show appropriate view controller
            let newVC = user == nil ? LoginViewController() : MainNavigationController(rootViewController: HomeTableViewController())
            if let currentVC = self.topViewController() {
                newVC.modalPresentationStyle = .overFullScreen
                newVC.modalPresentationCapturesStatusBarAppearance = true
                currentVC.present(newVC, animated: true)
            } else {
                window.rootViewController = newVC
            }
        }
        
        AppDevAnalytics.shared.logFirebase(AppLaunchedPayload())
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    // MARK: - Helper

    private func topViewController(viewController: UIViewController? = nil) -> UIViewController? {
        let vc = viewController ?? window?.rootViewController

        if let navigationController = vc as? UINavigationController {
            if let topController = navigationController.topViewController {
                return topViewController(viewController: topController)
            }
        } else if let tabController = vc as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(viewController: selected)
            }
        } else if let presented = vc?.presentedViewController {
            return topViewController(viewController: presented)
        }

        return vc
    }

}
