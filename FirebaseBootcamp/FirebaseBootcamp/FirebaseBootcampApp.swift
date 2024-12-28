//
//  FirebaseBootcampApp.swift
//  FirebaseBootcamp
//
//  Created by Suryakant Sharma on 25/12/24.
//

import SwiftUI
import Firebase

@main
struct FirebaseBootcampApp: App {
    
    init() {
        FirebaseApp.configure()
    }
  
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
        }
    }
}
