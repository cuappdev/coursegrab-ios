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

}

// MARK: - Methods

extension User {

    func signOut() {
        do {
            // TODO: Unsubscribe from notifications
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }

}
