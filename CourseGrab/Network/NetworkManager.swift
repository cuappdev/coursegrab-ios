//
//  NetworkManager.swift
//  CourseGrab
//
//  Created by Mathew Scullin on 2/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import FutureNova

class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()

    private let networking: Networking = URLSession.shared.request
    
    private init() { }
    
    func initializeSession(googleToken: String) -> Future<Response<SessionAuthorization>> {
        return networking(Endpoint.initializeSession(with: googleToken)).decode()
    }

    func updateSession() -> Future<Response<SessionAuthorization>> {
        return networking(Endpoint.updateSession()).decode()
    }

    func getAllTrackedCourses() -> Future<Response<[Section]>> {
        return validateToken()
            .chained { self.networking(Endpoint.getAllTrackedCourses()).decode() }
    }
    
    func searchCourse(query: String) -> Future<Response<[Course]>> {
        return validateToken()
            .chained { self.networking(Endpoint.searchCourse(query: query)).decode() }
    }

    func trackCourse(catalogNum: Int) -> Future<Response<Section>> {
        return validateToken()
            .chained { self.networking(Endpoint.trackCourse(catalogNum: catalogNum)).decode() }
    }

    func untrackCourse(catalogNum: Int) -> Future<Response<Section>> {
        return validateToken()
            .chained { self.networking(Endpoint.untrackCourse(catalogNum: catalogNum)).decode() }
    }
    
    func sendDeviceToken(deviceToken: String) -> Future<DeviceTokenResponse> {
        return validateToken()
            .chained { self.networking(Endpoint.sendDeviceToken(with: deviceToken)).decode() }
    }
    
    func enableNotifications(enabled: Bool) -> Future<Bool> {
        return validateToken()
            .chained { self.networking(Endpoint.enableNotifications(enabled: enabled)).decode() }
    }

    private func validateToken() -> Future<Void> {
        let promise = Promise<Void>()

        guard let user = User.current, let googleToken = user.googleToken else {
            promise.reject(with: NSError(
                domain: "",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey : "There is either no current user or google token."]
            ))
            return promise
        }

        guard let expiration = user.sessionAuthorization?.sessionExpiration else {
            return initializeSession(googleToken: googleToken).transformed { response in
                user.sessionAuthorization = response.data
            }
        }

        if expiration <= Date() {
            return updateSession().transformed { response in
                user.sessionAuthorization = response.data
            }
        } else {
            promise.resolve(with: ())
            return promise
        }
    }

}
