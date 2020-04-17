//
//  APNNotificationCenter.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 4/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class APNNotificationCenter {
    
    var gotSomething = false
    
    typealias Listener = (APNPayload) -> Void
    
    static let `default` = APNNotificationCenter()
    
    private init() { }
    
    private var listeners: [Listener] = []
    private var payloads: [APNPayload] = []
    
    /// Adds a listener and notifies the listener of any prior notifications
    func addListener(listener: @escaping Listener) {
        listeners.append(listener)
        // Notify the listener of all the payloads they might have missed
        for payload in payloads {
            listener(payload)
        }
    }
    
    /// Notifies all listeners of the payload
    func notify(payload: APNPayload) {
        payloads.append(payload)
        for listener in listeners {
            listener(payload)
        }
    }
    
}

