//
//  Timestamp.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 4/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

struct Timestamp: Codable {

    let date: Date

    init() {
        self.date = Date()
    }

    init(_ date: Date) {
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawDate = try container.decode(TimeInterval.self)
        date = Date(timeIntervalSince1970: rawDate)
    }

}

extension Timestamp: Equatable {

    static func == (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.date == rhs.date
    }

    static func <= (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.date <= rhs.date
    }

    static func >= (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.date >= rhs.date
    }

    static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.date < rhs.date
    }

    static func > (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.date > rhs.date
    }

}

extension Timestamp {

    static func == (lhs: Timestamp, rhs: Date) -> Bool {
        lhs.date == rhs
    }

    static func == (lhs: Date, rhs: Timestamp) -> Bool {
        lhs == rhs.date
    }

    static func <= (lhs: Timestamp, rhs: Date) -> Bool {
        lhs.date <= rhs
    }

    static func <= (lhs: Date, rhs: Timestamp) -> Bool {
        lhs <= rhs.date
    }

    static func >= (lhs: Timestamp, rhs: Date) -> Bool {
        lhs.date >= rhs
    }

    static func >= (lhs: Date, rhs: Timestamp) -> Bool {
        lhs >= rhs.date
    }

    static func < (lhs: Timestamp, rhs: Date) -> Bool {
        lhs.date < rhs
    }

    static func < (lhs: Date, rhs: Timestamp) -> Bool {
        lhs < rhs.date
    }

    static func > (lhs: Timestamp, rhs: Date) -> Bool {
        lhs.date > rhs
    }

    static func > (lhs: Date, rhs: Timestamp) -> Bool {
        lhs > rhs.date
    }

}
