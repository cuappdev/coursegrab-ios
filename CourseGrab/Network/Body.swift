//
//  Body.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/9/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

// MARK: - Request Bodies

struct SessionBody: Codable {
    
    let deviceToken: String?
    let deviceType: String
    let token: String
    
}

struct DeviceTokenBody: Codable {
    
    let deviceToken: String

}

struct QueryBody: Codable {

    let query: String

}

struct CoursePostBody: Codable {

    let courseId: Int

}

struct EnableNotificationsBody: Codable {

    let notification: String

}
