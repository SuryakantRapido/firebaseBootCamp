//
//  AuthenticationManager.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 25/12/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?

    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

final
class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() {}
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
       let result =  try await Auth.auth().createUser(withEmail: email, password: password)
       return AuthDataResultModel(user: result.user)
    }
}
