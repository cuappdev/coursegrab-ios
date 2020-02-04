//
//  CoursesNavigationController.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {

    // Source: https://stackoverflow.com/a/41248703/5078779

    private var navigationController: UINavigationController

    init(controller: UINavigationController) {
        self.navigationController = controller
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

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

        navigationBar.backIndicatorImage = UIImage.backIcon?.withInsets(UIEdgeInsets(top: 0, left: 8, bottom: 2.5, right: 0))
        navigationBar.backIndicatorTransitionMaskImage = .backIcon
    }

}

extension UIImage {

    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom),
            false,
            self.scale)

        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithInsets
    }

}
