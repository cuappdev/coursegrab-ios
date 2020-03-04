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
            if let dict = UserDefaults.standard.value(forKey: "sessionAuth") as? [String: Any],
                let sessionToken = dict["sessionToken"] as? String,
                let updateToken = dict["updateToken"] as? String,
                let sessionExpiration = dict["sessionExpiration"] as? Date {
                return SessionAuthorization(sessionExpiration: sessionExpiration, sessionToken: sessionToken, updateToken: updateToken)
            } else {
                return nil
            }
        }
        nonmutating set(token) {
            if let token = token {
                let dict: [String: Any] = [
                    "sessionToken": token.sessionToken,
                    "updateToken": token.updateToken,
                    "sessionExpiration": token.sessionExpiration,
                ]
                UserDefaults.standard.set(dict, forKey: "sessionAuth")
            } else {
                UserDefaults.standard.set(nil, forKey: "sessionAuth")
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
