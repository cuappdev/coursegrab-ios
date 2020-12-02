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
            UserDefaults.standard.value(forKey: "areNotificationsEnabled") as? Bool ?? true
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "areNotificationsEnabled")
        }
    }

    var didPromptPermission: Bool {
        get {
            UserDefaults.standard.bool(forKey: "didPromptPermission")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "didPromptPermission")
        }
    }
    
    var isLocalTimezoneEnabled: Bool {
        get {
            UserDefaults.standard.value(forKey: "localTimezoneEnabled") as? Bool ?? false
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "localTimezoneEnabled")
        }
    }
    
    var storedDeviceToken: String {
        get {
            UserDefaults.standard.string(forKey: "storeDeviceToken") ?? ""
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "storeDeviceToken")
        }
    }
}
