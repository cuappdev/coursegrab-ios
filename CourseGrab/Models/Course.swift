//
//  Course.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/5/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Course: Codable {

    let courseNum: Int
    let subjectCode: String
    let sections: [Section]
    let title: String

    var instructors: [String] {
        Array(Set(sections.reduce(into: [], { $0 += $1.instructors })))
    }

}

struct CourseSearch: Codable {

    let courses: [Course]
    let query: String

}
