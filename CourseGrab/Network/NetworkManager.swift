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
    
    private let networking: Networking = URLSession.shared.request
    
    static let shared: NetworkManager = NetworkManager()
    
    private init() { }
    
    func intializeSession(googleToken: String) -> Future<Response<SessionAuthorization>> {
        return networking(Endpoint.initializeSession(with: googleToken)).decode()
    }
    
    func updateSession() -> Future<Response<SessionAuthorization>> {
        return networking(Endpoint.updateSession()).decode()
    }
    
    func getAllTrackedCourses() -> Future<Response<[Section]>> {
        return networking(Endpoint.getAllTrackedCourses()).decode()
    }
    
    func trackCourse(catalogNum: Int) -> Future<Response<Section>> {
        return networking(Endpoint.trackCourse(catalogNum: catalogNum)).decode()
    }
    
    func untrackCourse(catalogNum: Int) -> Future<Response<Section>> {
        return networking(Endpoint.untrackCourse(catalogNum: catalogNum)).decode()
    }
    
    func searchCourse(query: String) -> Future<Response<[Course]>> {
        return networking(Endpoint.searchCourse(query: query)).decode()
    }
    
}
