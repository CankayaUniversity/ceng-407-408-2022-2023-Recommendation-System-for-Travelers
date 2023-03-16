//
//  FeedView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 24.02.2023.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel = FeedViewModel()
    
    var body: some View {
        ScrollView  {
            
            LazyVStack(spacing: 32){
                ForEach(viewModel.posts) { post in
                    FeedCell(viewModel: FeedCellViewModel(post: post))
                }
                
            }.padding(.top)
        }
    }
}

 
