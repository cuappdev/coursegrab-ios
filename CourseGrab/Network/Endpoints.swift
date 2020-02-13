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

        // Dummy configuration for the time being.
        #if LOCAL
            Endpoint.config.scheme = "http"
            Endpoint.config.port = 5000
        #else
            Endpoint.config.scheme = "https"
        #endif
            Endpoint.config.host = "dog.ceo"
            Endpoint.config.commonPath = "/api"
    }

    static var headers: [String: String] {
        // This will be changed once the user model is implemented.
        return [
            "Authorization": "Bearer <access_token>"
        ]
    }

    static func userAuthenticate(with token: String) -> Endpoint {
        let body = sessionBody(token: token) 
        return Endpoint(path: "/initialize/session/", body: body)
    }

    static func userUpdateSession() -> Endpoint {
        return Endpoint(path: "/auth/session/update/", headers: headers)
    }

    static func getAllTrackedCourses() -> Endpoint {
        return Endpoint(path: "/users/tracking/", headers: headers)
    }

    static func trackCourse(catalogNum: Int) -> Endpoint {
        let body = coursePostBody(courseId: catalogNum)
        return Endpoint(path: "/courses/track/", headers: headers, body: body)
    }

    static func unTrackCourse(catalogNum: Int) -> Endpoint {
        let body = coursePostBody(courseId: catalogNum)
        return Endpoint(path: "/courses/untrack/", headers: headers, body: body)
    }

}
