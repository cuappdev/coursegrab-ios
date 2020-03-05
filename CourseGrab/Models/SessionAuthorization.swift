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

extension SessionAuthorization {

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawDate = try values.decode(TimeInterval.self, forKey: .sessionExpiration)
        sessionExpiration = Date(timeIntervalSince1970: rawDate)
        sessionToken = try values.decode(String.self, forKey: .sessionToken)
        updateToken = try values.decode(String.self, forKey: .updateToken)
    }

}
