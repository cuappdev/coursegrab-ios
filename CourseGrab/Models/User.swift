//
//  User.swift
//  CourseGrab
//
//  Created by Daniel Vebman on 2/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import FirebaseAuth
import Foundation

struct User {

    static var current: User? {
        guard let email = Auth.auth().currentUser?.email,
            let name = Auth.auth().currentUser?.displayName,
            let id = Auth.auth().currentUser?.uid
            else { return nil }
        return User(email: email, name: name, id: id)
    }

    let email: String
    let name: String
    let id: String
    
    var sessionAuthorization: SessionAuthorization? {
        get {
            if let data = UserDefaults.standard.data(forKey: "sessionAuth"),
                let auth = try? JSONDecoder().decode(SessionAuthorization.self, from: data) {
                return auth
            } else {
                return nil
            }
        }
        nonmutating set(token) {
            if let data = try? JSONEncoder().encode(token) {
                UserDefaults.standard.set(data, forKey: "sessionAuth")
            }
        }
    }
    
    var googleToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "googleToken")
        }
        nonmutating set(token) {
            UserDefaults.standard.set(token, forKey: "googleToken")
        }
    }

}

// MARK: - Methods

extension User {
    
    func initializeSession() {
        guard let token = googleToken else {
            print("No token")
            return
        }
        NetworkManager.shared.initializeSession(googleToken: token).observe { response in
            switch response {
            case .value(let value):
                if value.success {
                    User.current?.sessionAuthorization = value.data
                } else {
                    print("No success")
                }
            case .error(let error):
                print(error)
            }
        }
    }

    func signOut() {
        sessionAuthorization = nil
        googleToken = nil
        do {
            // TODO: Unsubscribe from notifications
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }

}
