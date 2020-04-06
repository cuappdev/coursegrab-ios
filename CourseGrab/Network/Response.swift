//
//  Response.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/9/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {

    var data: T
    var success: Bool
    var timestamp: Date
    
}
