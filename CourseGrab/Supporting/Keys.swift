//
//  Secrets.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/28/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Secrets {

    static let announcementsCommonPath = Secrets.keyDict["announcements-common-path"] as! String
    static let announcementsHost = Secrets.keyDict["announcements-host"] as! String
    static let announcementsPath = Secrets.keyDict["announcements-path"] as! String
    static let announcementsScheme = Secrets.keyDict["announcements-scheme"] as! String
    static let googleClientID = Secrets.keyDict["google-client-id"] as! String
    static let serverHost = Secrets.keyDict["server-host"] as! String

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

}
