//
//  UIImage+Shared.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/3/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    static let backIcon = UIImage(named: "icon-back")
    static let searchIcon = UIImage(named: "icon-search")
    static let settingsIcon = UIImage(named: "icon-settings")

    func with(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(
                width: size.width + insets.left + insets.right,
                height: size.height + insets.top + insets.bottom
            ),
            false,
            self.scale
        )

        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithInsets
    }

}
