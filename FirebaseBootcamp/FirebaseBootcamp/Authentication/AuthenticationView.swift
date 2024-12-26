//
//  AuthenticationView.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 25/12/24.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView()
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
            Spacer()
        }.navigationTitle("Sign In")
        
    }
}

#Preview {
    NavigationStack {
        AuthenticationView()
    }
}
