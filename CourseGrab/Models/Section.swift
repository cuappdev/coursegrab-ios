//
//  Section.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 1/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import DifferenceKit
import Foundation
import UIKit

enum Status: String, Codable {
    
    case closed = "CLOSED"
    case open = "OPEN"
    case waitlist = "WAITLIST"

    var icon: UIImage {
        let contextSize = CGSize(width: 72, height: 72)
        let renderer = UIGraphicsImageRenderer(size: contextSize)
        return renderer.image { context in
            switch self {
            case .closed:
                UIColor.courseGrabRuby.setFill()
                let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: contextSize), cornerRadius: contextSize.height / 8).cgPath
                context.cgContext.addPath(path)
                context.cgContext.closePath()
                context.cgContext.fillPath()
            case .open:
                UIColor.courseGrabGreen.setFill()
                let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: contextSize), cornerRadius: contextSize.height / 2).cgPath
                context.cgContext.addPath(path)
                context.cgContext.closePath()
                context.cgContext.fillPath()
            case .waitlist:
                UIColor.courseGrabYellow.setFill()
                context.cgContext.move(to: CGPoint(x: 0, y: contextSize.height * (2 + sqrt(3)) / 4))
                context.cgContext.addLine(to: CGPoint(x: contextSize.width, y: contextSize.height * (2 + sqrt(3)) / 4))
                context.cgContext.addLine(to: CGPoint(x: contextSize.width / 2, y: contextSize.height * (2 - sqrt(3)) / 4))
                context.cgContext.closePath()
                context.cgContext.fillPath()
            }
        }
    }
    
}

struct Section: Codable {

    let catalogNum: Int
    let courseNum: Int
    let instructors: [String]
    let isTracking: Bool
    let section: String
    let status: Status
    let subjectCode: String
    let title: String
    
}

extension Section: Differentiable {

    typealias DifferenceIdentifier = Data

    var differenceIdentifier: Data {
        if let data = try? JSONEncoder().encode(self) {
            return data
        }
        return Data()
    }

    func isContentEqual(to source: Section) -> Bool {
        return differenceIdentifier == source.differenceIdentifier
    }

}
