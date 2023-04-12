//
//  CommentsCell.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 20.03.2023.
//

import SwiftUI
import Kingfisher

struct CommentsCell: View {
     let comment : Comment
    var body: some View {
        
        HStack{
            KFImage(URL(string: comment.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            
            Text(comment.username)
                .font(.system(size: 14, weight: .semibold)) +
            Text("\(comment.commentText)")
                .font(.system(size: 14))
            
            
            Spacer()
            
            Text("2m")
                .foregroundColor(.gray)
                .font(.system(size: 12))
                .padding(.trailing)
        }.padding(.horizontal)
    }
}
