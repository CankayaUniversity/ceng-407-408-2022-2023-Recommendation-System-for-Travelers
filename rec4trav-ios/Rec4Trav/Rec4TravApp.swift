//
//  Rec4TravApp.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 16.03.2023.
//

import SwiftUI
import Firebase

@main
struct Rec4TravApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared).environmentObject(LocalSearchService())
        }
    }
}
