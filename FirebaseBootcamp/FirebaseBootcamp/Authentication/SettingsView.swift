//
//  SettingsView.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 26/12/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
        
    func logout() {
        do {
            try AuthenticationManager.shared.signOut()
        } catch {
            print("Error in signout: \(error)")
        }
    }
    
    func onViewAppear() async throws {
       try await ProductsManager.shared.fetchProductAndStoreInFirestore()
    }
}


struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Logout") {
               viewModel.logout()
               showSignInView = true
            }
            
            NavigationLink {
                ProductListView()
            } label: {
                Label("Products", systemImage: "person")
            }
        }
        .task {
            do {
                try await viewModel.onViewAppear()
            } catch {
                print("Error in fetching products: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
