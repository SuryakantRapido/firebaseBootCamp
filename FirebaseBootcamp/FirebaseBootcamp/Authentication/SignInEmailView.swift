//
//  SignInEmailView.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 25/12/24.
//

import SwiftUI

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn()  {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password is empty")
            return
        }
        Task {
            do {
                let model = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("User created : \(model)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

struct SignInEmailView: View {
    
    @StateObject var viewModel = SignInViewModel()
    
    var body: some View {
        VStack {
            TextField("Email",
                      text: $viewModel.email)
                .padding()
                .background(.gray.opacity(0.4))
                .cornerRadius(10)

            SecureField("Password",
                        text: $viewModel.password)
            .padding()
            .background(.gray.opacity(0.4))
            .cornerRadius(10)
            
            
            Button {
                viewModel.signIn()
            } label: {
                Text("Sign In with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In with Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView()
    }
}
