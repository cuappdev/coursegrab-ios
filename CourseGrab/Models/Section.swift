//
//  Section.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

enum Status: String, Codable {
    case closed, open, waitlist
}

struct Section: Codable {

    let catalogNum: Int
    let courseNum: Int
    let section: String
    let status: Status
    let subjectCode: String
    let title: String
    
}
