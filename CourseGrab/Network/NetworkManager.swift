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

    func getAllTrackedSections() -> Future<Response<[Section]>> {
        return validateToken()
            .chained { self.networking(Endpoint.getAllTrackedSections()).decode() }
    }
    
    func searchCourse(query: String) -> Future<Response<[Course]>> {
        return validateToken()
            .chained { self.networking(Endpoint.searchCourse(query: query)).decode() }
    }

    func trackSection(catalogNum: Int) -> Future<Response<Section>> {
        return validateToken()
            .chained { self.networking(Endpoint.trackSection(catalogNum: catalogNum)).decode() }
    }

    func untrackSection(catalogNum: Int) -> Future<Response<Section>> {
        return validateToken()
            .chained { self.networking(Endpoint.untrackSection(catalogNum: catalogNum)).decode() }
    }
    
    func getSection(catalogNum: Int) -> Future<Response<Section>> {
        return validateToken()
            .chained { self.networking(Endpoint.getSection(catalogNum: catalogNum)).decode() }
    }
    
    func sendDeviceToken(deviceToken: String) -> Future<DeviceTokenResponse> {
        return validateToken()
            .chained { self.networking(Endpoint.sendDeviceToken(with: deviceToken)).decode() }
    }
    
    func enableNotifications(enabled: Bool) -> Future<EnableNotificationsResponse> {
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
                // update local session authorization
                user.sessionAuthorization = response.data
                
                // update server notification settings to match local
                // reasoning: we put this here because
                // (1) it is called when the user first signs in
                //     - we don't ever use `initializeSession` because the Google Auth flow is the
                //       same for logging in for the first time as for logging in once the user has
                //       already signed in before. It would be unnecessarily repetitive to update the
                //       notification status on every app launch.
                // (2) it is not called often
                _ = self.enableNotifications(enabled: UserDefaults.standard.areNotificationsEnabled)
            }
        } else {
            promise.resolve(with: ())
            return promise
        }
    }

}
