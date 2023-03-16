//
//  ProfileHeaderView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 4.03.2023.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                KFImage(URL(string: viewModel.user.profileImageUrl ))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80,height: 80)
                    .clipped()
                
                .clipShape(Circle())
                .padding(.leading)
                Spacer()
                
                HStack( spacing: 16){
                    
                    UserStatView(value: 13, title: "Posts")
                    UserStatView(value: 19248, title: "Followers")
                    UserStatView(value: 17, title: "Following")
                    
                }.padding(.trailing,32)
            }
          //  Spacer()
            Text(viewModel.user.username)
                .font(.system(size: 15, weight: .semibold))
                .padding([.leading, .top])
            
            Text(viewModel.user.fullname)
                .font(.system(size: 15))
                .padding(.leading)
                .padding(.top,1)
            
            
            HStack {
                Spacer()
                ProfileActionButtonView(viewModel: viewModel)
                Spacer()
            }.padding(.top,6)
        }//.padding(.horizontal)
    }
}



