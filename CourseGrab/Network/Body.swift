//
//  Body.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/9/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

// MARK: - Request Bodies

internal struct sessionBody: Codable {
    let token: String
}

internal struct coursePostBody: Codable {
    let courseId: Int
}

internal struct queryBody: Codable {
    let query: String
}
