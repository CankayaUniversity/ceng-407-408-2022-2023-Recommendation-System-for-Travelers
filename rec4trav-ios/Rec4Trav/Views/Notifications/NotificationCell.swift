//
//  NotificationCell.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 3.03.2023.
//

import SwiftUI

struct NotificationCell: View {
    @State private var showPostImage = false
    var body: some View {
        HStack{
            Image("tom")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .clipped()
            
            Text("Tom Hardy  ")
                .font(.system(size: 15, weight: .semibold)) +
            Text("liked one of your posts.")
                .font(.system(size: 14))
            
            Spacer()
            
            if showPostImage{
                Image("tom")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipped()
                 //   .padding(.horizontal, 5)

            }else{
                Button(action: {
                    
                }, label: {
                    Text("Follow")
                        .padding(.horizontal, 20)
                        .padding(.vertical,8)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .font(.system(size: 14, weight: .semibold))
                })
            }
        }.padding(.horizontal)
    }
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell()
    }
}
