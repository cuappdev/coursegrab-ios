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
        timestamp = Date(timeIntervalSince1970: rawDate)
        success = try values.decode(Bool.self, forKey: .success)
        data = try values.decode(T.self, forKey: .data)
    }
}
