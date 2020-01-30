//
//  UIFont+Shared.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

extension UIFont {

    static let _14Regular = UIFont.systemFont(ofSize: 14)
    static let _16Regular = UIFont.systemFont(ofSize: 16)
    static let _18Regular = UIFont.systemFont(ofSize: 18)

    static let _14Medium = UIFont.systemFont(ofSize: 14, weight: .medium)

    static let _12Semibold = UIFont.systemFont(ofSize: 12, weight: .semibold)
    static let _14Semibold = UIFont.systemFont(ofSize: 14, weight: .semibold)
    static let _16Semibold = UIFont.systemFont(ofSize: 16, weight: .semibold)
    static let _18Semibold = UIFont.systemFont(ofSize: 18, weight: .semibold)
    static let _20Semibold = UIFont.systemFont(ofSize: 20, weight: .semibold)

    static let _20Bold = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let _30Bold = UIFont.systemFont(ofSize: 30, weight: .bold)
    static let _36Bold = UIFont.systemFont(ofSize: 36, weight: .bold)

}
