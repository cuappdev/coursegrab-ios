//
//  Response.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/9/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {

    let data: T
    let success: Bool
    let timestamp: Timestamp
    
}

struct DeviceTokenResponse: Codable {

    let success: Bool
    let timestamp: Timestamp
    
}

