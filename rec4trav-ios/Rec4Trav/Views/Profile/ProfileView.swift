//
//  ProfileView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 24.02.2023.
//

import SwiftUI

struct ProfileView: View {
    
    let user : User
    
    @ObservedObject var viewModel: ProfileViewModel
    
    init(user: User){
        self.user = user
        self.viewModel = ProfileViewModel(user: user)
    }
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 32){
                ProfileHeaderView(viewModel: viewModel)
                PostGridView(config: .profile(user.id ?? ""))
            }.padding(.top)
        }
    }
}

