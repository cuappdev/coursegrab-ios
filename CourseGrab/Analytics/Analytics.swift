//
//  Analytics.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 4/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import FirebaseAnalytics
import Foundation
import UIKit

protocol Payload {
    var eventName: String { get }
    var parameters: [String: Any]? { get }
}

extension Payload {
    var parameters: [String: Any]? {
        return nil
    }
}

class AppDevAnalytics {

    static let shared = AppDevAnalytics()

    private init() {}

    func logFirebase(_ payload: Payload) {
        #if !DEBUG
        Analytics.logEvent(payload.eventName, parameters: payload.parameters)
        #else
        print("[Debug]: Logged event: \(payload.eventName), parameters: \(payload.parameters?.description ?? "nil")")
        #endif
    }

}

// MARK: - Event Payloads

/// Log app launch with device info
struct AppLaunchedPayload: Payload {
    
    let eventName: String = "app_launched"
    var parameters: [String : Any]? {
        return ["device_info": UIDevice.modelName]
    }

}

/// Log  app launch by notification
struct NotificationPressPayload: Payload {
    
    let eventName = "notification_press"
    var parameters: [String : Any]? {
        return ["device_info": UIDevice.modelName]
    }
    
}

/// Log when search icon is pressed
struct SearchIconPressPayload: Payload {
    
    let eventName = "search_icon_press"
    var parameters: [String : Any]? {
        return ["device_info": UIDevice.modelName]
    }
    
}

/// Log when Open Student Center button is pressed
struct OpenStudentCenterPressPayload: Payload {
    
    let eventName = "open_student_center_press"
    var parameters: [String : Any]? {
        return ["device_info": UIDevice.modelName]
    }
    
}

/// Log when Cornell Academic Calendar  button is pressed
struct CornellCalendarPressPayload: Payload {
    
    let eventName = "cornell_calendar_press"
    var parameters: [String : Any]? {
        return ["device_info": UIDevice.modelName]
    }
    
}

/// Log  mobile alert toggle
struct MobileAlertPressPayload: Payload {
    
    let eventName = "mobile_alert_press"
    var parameters: [String : Any]? {
        return ["device_info": UIDevice.modelName]
    }
    
}

/// Log any errors when sending feedback
struct FeedbackErrorPayload: Payload {
    
    let eventName: String = "feedback_error"
    let description: String
    var parameters: [String : Any]? {
        return ["description": description,
                "device_info": UIDevice.modelName]
    }
    
}

/// Log success when sending feedback
struct FeedbackSuccessPayload: Payload {
    
    let eventName: String = "feedback_success"
    var parameters: [String : Any]? {
        return ["device_info": UIDevice.modelName]
    }
    
}

/// Log when CourseDetailView is launched for a class
struct CourseDetailPressPayload: Payload {
    
    let eventName = "course_detail_press"
    let courseTitle: String
    var parameters: [String : Any]? {
        return ["course_title": courseTitle,
                "device_info": UIDevice.modelName]
    }
    
}

/// Log search query
struct SearchedQueryPayload: Payload {
    
    let eventName = "search_query"
    let query: String
    var parameters: [String : Any]? {
        return ["search_query": query,
                "device_info": UIDevice.modelName]
    }
    
}

/// Log when section is tracked
struct TrackSectionPayload: Payload {
    
    let eventName = "track_section_press"
    let courseTitle: String
    let catalogNum: Int
    var parameters: [String : Any]? {
        return ["catalog_num": catalogNum,
                "course_name": courseTitle,
                "device_info": UIDevice.modelName]
    }
    
}

/// Log when section is untracked
struct UntrackSectionPayload: Payload {
    
    let eventName = "untrack_section_press"
    let courseTitle: String
    let catalogNum: Int
    var parameters: [String : Any]? {
        return ["catalog_num": catalogNum,
                "course_title": courseTitle,
                "device_info": UIDevice.modelName]
    }
    
}

/// Log enroll button press
struct EnrollSectionPressPayload: Payload {
    
    let eventName = "enroll_section_press"
    let courseTitle: String
    let catalogNum: Int
    var parameters: [String : Any]? {
        return ["catalog_num": catalogNum,
                "course_title": courseTitle,
                "device_info": UIDevice.modelName]
    }
    
}

/// Log number of tracked sections
struct NumberOfTrackedSectionsPayload: Payload {
    
    let eventName = "enroll_section_press"
    let numberOfSections: Int
    var parameters: [String : Any]? {
        return ["number_of_sections": numberOfSections,
                "device_info": UIDevice.modelName]
    }
    
}

/// Log when an announcement is presented to the user
struct AnnouncementPresentedPayload: Payload {
    
    let eventName = "announcement_presented"
    
}
