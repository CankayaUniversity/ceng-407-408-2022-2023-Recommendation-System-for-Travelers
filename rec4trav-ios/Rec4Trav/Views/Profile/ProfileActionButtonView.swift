//
//  ProfileActionButtonView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 4.03.2023.
//

import SwiftUI

struct ProfileActionButtonView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    var isFollowed: Bool { return viewModel.user.isFollowed ?? false }
    
    var body: some View {
        if viewModel.user.isCurrentUser{
            //edit profile button
            Button(action: {
            //viewModel.follow()
            }, label: {
                Text("Edit Profile")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 360, height: 32)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray,lineWidth: 1)
                    )
        })
        }else{
            //follow and message button
            HStack(spacing:16){
                Button(action: {  isFollowed ? viewModel.unfollow() : viewModel.follow() }, label: {
                    Text(isFollowed ? "Following" : "Follow")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(width: 180, height: 32)

                        .foregroundColor(isFollowed ? .black : .white)
                        .background(isFollowed ? Color.white : Color.blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray,lineWidth: isFollowed ? 1 : 0)
                        ).cornerRadius(5)
            })
                Button(action: {
                    //Message view
                }, label: {
                    Text("Message")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 180, height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray,lineWidth: 1)
                        )
            })
            }
        }
    }
}
