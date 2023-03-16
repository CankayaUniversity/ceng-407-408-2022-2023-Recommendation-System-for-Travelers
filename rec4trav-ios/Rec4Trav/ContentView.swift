//
//  ContentView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 24.02.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @State var selectedIndex = 0
    var body: some View {
        Group{
            //if not logged in show login page
            //if logged in show main page
            if viewModel.userSession == nil {
                LoginView()
            }else{
                if let user = viewModel.currentUser{
                    MainTabView(user: user, selectedIndex: $selectedIndex)
                    
                }
            }
        }
    }
}



