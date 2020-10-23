//
//  UserDefaults.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/9/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

extension UserDefaults {

    var didPromptPermission: Bool {
        get {
            UserDefaults.standard.bool(forKey: "didPromptPermission")
        }
        set(bool) {
            UserDefaults.standard.set(bool, forKey: "didPromptPermission")
        }
    }

    var areNotificationsEnabled: Bool {
        get {
            UserDefaults.standard.value(forKey: "areNotificationsEnabled") as? Bool ?? true
        }
        set(bool) {
            UserDefaults.standard.set(bool, forKey: "areNotificationsEnabled")
        }
    }

}
