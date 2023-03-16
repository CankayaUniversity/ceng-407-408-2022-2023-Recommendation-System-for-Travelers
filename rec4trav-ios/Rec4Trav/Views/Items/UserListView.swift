//
//  UserListView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 3.03.2023.
//

import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: SearchViewModel
    @Binding var searchText: String
    
    var users: [User]{
        return searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)
    }
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVStack(spacing:15){
                ForEach(users) { user in
                    NavigationLink(destination: ProfileView(user: user),
                                   label: {
                        UserCell(user: user)
                        .padding(.leading)
                        
                    })
                }
            }
        }
    }
}

