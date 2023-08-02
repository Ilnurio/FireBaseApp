//
//  User.swift
//  FireBaseApp
//
//  Created by Ilnur on 31.07.2023.
//

import Foundation
import Firebase

struct Person {
    let uid: String
    let email: String
    
    init(person: User) {
        self.uid = person.uid
        self.email = person.email!
    }
}
