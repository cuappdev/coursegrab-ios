//
//  SessionTokens.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct SessionAuthorization: Codable {

    let sessionExpiration: Date
    let sessionToken: String
    let updateToken: String
    
}
