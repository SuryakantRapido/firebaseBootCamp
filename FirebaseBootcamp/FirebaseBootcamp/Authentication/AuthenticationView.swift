//
//  AuthenticationView.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 25/12/24.
//

import SwiftUI

@MainActor
final class AuthenticationVIewModel: ObservableObject {
    
    func signInAnonymously() async {
        do {
            let result = try await AuthenticationManager.shared.signInAnonymously()
            print("Sign in anonymously success: \(result)")
            
        } catch {
            print("Error in sign in anonymously: \(error)")
        }
    }
}

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    @StateObject var viewModel = AuthenticationVIewModel()
        
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding()
            }
            
            Button {
                Task {
                    await viewModel.signInAnonymously()
                    showSignInView = false 
                }
            } label: {
                Text("Sign In Anonymously")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding()
            }
            
            Spacer()
        }.navigationTitle("Sign In")
        
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(true))
    }
}
