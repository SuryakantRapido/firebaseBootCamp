//
//  RootView.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 26/12/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authenticated = try? AuthenticationManager.shared.getAuthenticationUser()
            showSignInView = authenticated == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
