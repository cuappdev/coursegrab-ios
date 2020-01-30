//
//  Secrets.swift
//  CourseGrab
//
//  Created by Reade Plunkett on 1/28/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Secrets {
    
    static let googleClientID = Secrets.keyDict["google-client-id"] as! String

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

}
