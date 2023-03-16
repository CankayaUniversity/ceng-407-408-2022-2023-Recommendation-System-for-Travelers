//
//  PostGridView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 3.03.2023.
//

import SwiftUI
import Kingfisher

struct PostGridView: View {
    private let gridItems = [GridItem(),GridItem(),GridItem()]
    private let width = UIScreen.main.bounds.width / 3
    let config : PostGridConfiguration
    @ObservedObject var viewModel : PostGridViewModel
    
    init(config: PostGridConfiguration) {
        self.config = config
        self.viewModel = PostGridViewModel(config: config)
    }
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 2,content: {
            ForEach(viewModel.posts) { post in
                    NavigationLink(destination: FeedView(), label: {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: width)
                            .clipped()
                    })
            }
        
        })
    }
}


