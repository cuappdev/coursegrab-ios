//
//  UserDefaults.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/9/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var areNotificationsEnabled: Bool {
        get {
            return UserDefaults.standard.value(forKey: "areNotificationsEnabled") as? Bool ?? true
        }
        set(bool) {
            UserDefaults.standard.set(bool, forKey: "areNotificationsEnabled")
        }
    }

    var didPromptPermission: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "didPromptPermission")
        }
        set(bool) {
            UserDefaults.standard.set(bool, forKey: "didPromptPermission")
        }
    }
    
    var storedDeviceToken: String {
        get {
            return UserDefaults.standard.string(forKey: "storeDeviceToken") ?? ""
        }
        set(string) {
            UserDefaults.standard.set(string, forKey: "storeDeviceToken")
        }
    }
    
}
