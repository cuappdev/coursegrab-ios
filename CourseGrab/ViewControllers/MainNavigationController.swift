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

// MARK: - BigHitNavigationBar

private class BigHitNavigationBar: UINavigationBar {

    private let tapOffset: CGFloat = 40

    weak var navigationController: UINavigationController?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if bounds.insetBy(dx: 0, dy: -tapOffset).contains(point), let item = navigationController?.topViewController?.navigationItem {
            var candidateViews = [
                item.backBarButtonItem?.customView,
                item.leftBarButtonItem?.customView,
                item.rightBarButtonItem?.customView
            ].compactMap { $0 }
            item.leftBarButtonItems?
                .compactMap { $0.customView }
                .forEach { candidateViews.append($0) }
            item.rightBarButtonItems?
                .compactMap { $0.customView }
                .forEach { candidateViews.append($0) }

            for view in candidateViews {
                let viewFrame = view.convert(view.frame, to: self).insetBy(dx: -tapOffset, dy: -tapOffset)
                if viewFrame.contains(point) {
                    return view
                }
            }
        }

        return super.hitTest(point, with: event)
    }

}

// MARK: - MainNavigationController

class MainNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: BigHitNavigationBar.self, toolbarClass: nil)
        (navigationBar as? BigHitNavigationBar)?.navigationController = self
        setViewControllers([rootViewController], animated: false)
        
        APNNotificationCenter.default.addListener { [weak self] payload in
            print("Got payload")
            guard let self = self else { return }
            let vc = NotificationModalViewController(payload: payload)
            self.pushViewController(vc, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
