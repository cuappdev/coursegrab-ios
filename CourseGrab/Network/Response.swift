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
    let timestamp: Date
    
}

extension Response {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawDate = try values.decode(TimeInterval.self, forKey: .timestamp)
        data = try values.decode(T.self, forKey: .data)
        success = try values.decode(Bool.self, forKey: .success)
        timestamp = Date(timeIntervalSince1970: rawDate)
    }
    
}

struct DeviceTokenResponse: Codable {

    let success: Bool
    let timestamp: Date
    
}

extension DeviceTokenResponse {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawDate = try values.decode(TimeInterval.self, forKey: .timestamp)
        success = try values.decode(Bool.self, forKey: .success)
        timestamp = Date(timeIntervalSince1970: rawDate)
    }
    
}

