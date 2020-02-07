//
//  CoursesNavigationController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

// MARK: - InteractivePopRecognizer

class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {

    // Source: https://stackoverflow.com/a/41248703/5078779

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

// MARK: - MainNavigationController

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = .black
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont._20Semibold]

        // Add insets to the back button so it perfectly aligns with the HomeTableViewController back button.
        navigationBar.backIndicatorImage = UIImage.backIcon?.with(insets: UIEdgeInsets(top: 0, left: 8, bottom: 2.5, right: 0))
        navigationBar.backIndicatorTransitionMaskImage = .backIcon
    }

}
