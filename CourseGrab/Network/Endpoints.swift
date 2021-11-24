//
//  Endpoints.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/9/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {

    static func setupEndpointConfig() {
        Endpoint.config.keyDecodingStrategy = .convertFromSnakeCase
        Endpoint.config.keyEncodingStrategy = .convertToSnakeCase

        #if DEBUG
        Endpoint.config.scheme = "http"
        Endpoint.config.port = 5000
        Endpoint.config.host = "0.0.0.0"
        #else
        Endpoint.config.scheme = "https"
        Endpoint.config.host = Secrets.serverHost
        #endif
        Endpoint.config.commonPath = "/api"
    }

    static var standardHeaders: [String: String] {
        if let token = User.current?.sessionAuthorization?.sessionToken {
            return ["Authorization": token]
        } else {
            return [:]
        }
    }

    static var updateHeaders: [String: String] {
        if let token = User.current?.sessionAuthorization?.updateToken {
            return ["Authorization": token]
        } else {
            return [:]
        }
    }

    static func initializeSession(with token: String) -> Endpoint {
        let deviceToken = UserDefaults.standard.storedDeviceToken == "" ? nil : UserDefaults.standard.storedDeviceToken
        let body = SessionBody(deviceToken: deviceToken, deviceType: "IOS", token: token)
        return Endpoint(path: "/session/initialize/", body: body)
    }

    static func updateSession() -> Endpoint {
        Endpoint(path: "/session/update/", headers: updateHeaders, method: .post)
    }

    static func getAllTrackedSections() -> Endpoint {
        Endpoint(path: "/users/tracking/", headers: standardHeaders)
    }

    static func searchCourse(query: String) -> Endpoint {
        let body = QueryBody(query: query)
        return Endpoint(path: "/courses/search/", headers: standardHeaders, body: body)
    }

    static func trackSection(catalogNum: Int) -> Endpoint {
        let body = CoursePostBody(courseId: catalogNum)
        return Endpoint(path: "/sections/track/", headers: standardHeaders, body: body)
    }

    static func untrackSection(catalogNum: Int) -> Endpoint {
        let body = CoursePostBody(courseId: catalogNum)
        return Endpoint(path: "/sections/untrack/", headers: standardHeaders, body: body)
    }

    static func getSection(catalogNum: Int) -> Endpoint {
        Endpoint(path: "/sections/\(catalogNum)/", headers: standardHeaders)
    }

    static func sendDeviceToken(with deviceToken: String) -> Endpoint {
        let body = DeviceTokenBody(deviceToken: deviceToken)
        return Endpoint(path: "/users/device-token/", headers: standardHeaders, body: body)
    }

    static func enableNotifications(enabled: Bool) -> Endpoint {
        let body = EnableNotificationsBody(notification: enabled ? "IOS" : "NONE")
        return Endpoint(path: "/users/notification/", headers: standardHeaders, body: body)
    }
    static func getCourse(courseNum: Int) -> Endpoint{
        return Endpoint(path: "/courses/\(courseNum)/", headers: standardHeaders )
    }
}
