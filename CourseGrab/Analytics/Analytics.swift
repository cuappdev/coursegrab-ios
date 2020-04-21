//
//  Analytics.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 4/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import FirebaseAnalytics

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

// MARK: Event Payloads
/// Log whenever Search icon is pressed
struct SearchIconPressPayload: Payload {
    let eventName = "collegetown_pill_press"
}

/// Log whenever Open Student Center button is pressed
struct OpenStudentCenterPressPayload: Payload {
    let eventName = "campus_pill_press"
}

/// Log whenever Cornell Academic Calendar  button is pressed
struct CornellCalendarPressPayload: Payload {
    let eventName = "lookahead_tab_press"
}

/// Log whenever BRB Account tab bar button is pressed
struct BRBPressPayload: Payload {
    let eventName = "brb_tab_press"
}

/// Log whenever homescreen map button is pressed
struct MapPressPayload: Payload {
    let eventName = "homescreen_map_press"
}

/// Log whenever the Nearest filter is pressed (on x view)
struct NearestFilterPressPayload: Payload {
    let eventName = "nearest_filter_press"
}

/// Log whenever the North filter is pressed
struct NorthFilterPressPayload: Payload {
    let eventName = "north_filter_press"
}

/// Log whenever the West filter is pressed
struct WestFilterPressPayload: Payload {
    let eventName = "west_filter_press"
}

/// Log whenever the Central filter is pressed
struct CentralFilterPressPayload: Payload {
    let eventName = "central_filter_press"
}

/// Log whenever the Swipes filter is pressed
struct SwipesFilterPressPayload: Payload {
    let eventName = "swipes_filter_press"
}

/// Log whenever the BRB filter is pressed
struct BRBFilterPressPayload: Payload {
    let eventName = "brb_filter_press"
}

/// Log whenever BRB Account login button is pressed
struct BRBLoginPressPayload: Payload {
    let eventName = "user_brb_login"
}

/// Log whenever any Collegetown filter is pressed
struct CollegetownFilterPressPayload: Payload {
    let eventName = "collegetown_filters_press"
}

/// Log whenever CourseDetailView is launched for a class
struct CourseDetailPressPayload: Payload {
    let eventName = "eatery_tab_press"
    let courseName: String
    var parameters: [String : Any]? {
        return ["course_name": courseName]
    }
}

/// Log whenever any Campus dining cell is pressed
struct CampusDiningCellPressPayload: Payload {
    let eventName = "campus_dining_hall_press"
    let diningHallName: String
    var parameters: [String : Any]? {
        return ["dining_hall_name": diningHallName]
    }
}

/// Log whenever any Campus cafe (no swipes) cell is pressed
struct CampusCafeCellPressPayload: Payload {
    let eventName = "campus_cafe_press"
    let cafeName: String
    var parameters: [String : Any]? {
        return ["cafe_name": cafeName]
    }
}

/// Log whenever any Collegetown cell is pressed
struct CollegetownCellPressPayload: Payload {
    let eventName = "collegetown_eatery_press"
}

/// Log whenever an announcement is presented to the user
struct AnnouncementPresentedPayload: Payload {
    let eventName = "announcement_presented"
}
