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

        #if LOCAL
        Endpoint.config.scheme = "http"
        Endpoint.config.port = 5000
        #else
        Endpoint.config.scheme = "https"
        #endif
        Endpoint.config.host = Secrets.serverHost
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
        let body = SessionBody(token: token)
        return Endpoint(path: "/session/initialize/", body: body)
    }

    static func updateSession() -> Endpoint {
        return Endpoint(path: "/session/update/", headers: updateHeaders, method: .post)
    }

    static func getAllTrackedCourses() -> Endpoint {
        return Endpoint(path: "/users/tracking/", headers: standardHeaders)
    }
    
    static func searchCourse(query: String) -> Endpoint {
        let body = QueryBody(query: query)
        return Endpoint(path: "/courses/search/", headers: standardHeaders, body: body)
    }

    static func trackCourse(catalogNum: Int) -> Endpoint {
        let body = CoursePostBody(courseId: catalogNum)
        return Endpoint(path: "/sections/track/", headers: standardHeaders, body: body)
    }

    static func untrackCourse(catalogNum: Int) -> Endpoint {
        let body = CoursePostBody(courseId: catalogNum)
        return Endpoint(path: "/sections/untrack/", headers: standardHeaders, body: body)
    }
    
    static func sendDeviceToken(with deviceToken: String) -> Endpoint {
        let body = DeviceTokenBody(deviceToken: deviceToken)
        return Endpoint(path: "/users/device-token/", headers: standardHeaders, body: body)
    }

}
