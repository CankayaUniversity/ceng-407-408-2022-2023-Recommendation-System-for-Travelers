//
//  FeedCell.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 24.02.2023.
//

import SwiftUI
import Kingfisher

struct FeedCell: View {
    @ObservedObject var viewModel : FeedCellViewModel
    
    var didLike : Bool { return viewModel.post.didLike ?? false }
     
    init(viewModel: FeedCellViewModel){
        self.viewModel = viewModel
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                //User info
                KFImage(URL(string: viewModel.post.ownerImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipped()
                    .cornerRadius(18)
                
                Text(viewModel.post.ownerUsername)
                    .font(.system(size: 14, weight: .semibold))
                
                Spacer()
            }.padding(.leading, 8)
            //viewModel.post Image
           KFImage(URL(string: viewModel.post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 440)
                .clipped()
                
            
            //Action buttons
            HStack(spacing:15){
            Button(action: {
                didLike ? viewModel.unlike() : viewModel.like()

            }, label: {
                Image(systemName: didLike ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(didLike ? .red : .black)
                    .frame(width: 20, height: 20)
                
            })
            
           /* Button(action: {}, label: {
                    Image(systemName: "bubble.left")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                })*/
                
                NavigationLink(destination: CommentsView(post: viewModel.post), label: {
                    Image(systemName: "bubble.left")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                })
            
            Button(action: {}, label: {
                    Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                })
                
            }
            .foregroundColor(.black)
            .padding(.horizontal,10)
            .padding(.vertical,5)
            //Caption
            
            Text("\(viewModel.likeString)")
                .font(.system(size: 14, weight: .semibold))
                .padding(.leading,10)
                .padding(.bottom,2)
            HStack{
                Text(viewModel.post.ownerUsername)
                    .font(.system(size: 16, weight: .semibold)) +
                Text("\(viewModel.post.caption)")
                    .font(.system(size: 14))
                
            }
            .padding(.horizontal,10)

            Text("12h")
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(.top,2)
                .padding(.horizontal,10)
                .padding(.top,-2)

        }.padding(1)
    }
}
