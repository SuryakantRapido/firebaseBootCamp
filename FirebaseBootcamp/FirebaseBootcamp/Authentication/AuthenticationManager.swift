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
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: result.user)
    }
    
    func getAuthenticationUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "com.firebase", code: 404, userInfo: ["message": "User not found"])
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw NSError(domain: "com.firebase", code: 404, userInfo: ["message": "User not found"])
        }
    }
    
    func signInAnonymously() async throws -> AuthDataResultModel {
        let result = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: result.user)
    }
}
