//
//  FeedVew.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 12.03.2023.
//

import Foundation

class FeedViewModel: ObservableObject{
    @Published var posts = [Post]()
    
    init(){
        fetchPosts()
    }
    
    func fetchPosts(){
        COLLECTION_POSTS.getDocuments{ snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.posts = documents.compactMap({ try? $0.data(as: Post.self)})
         
            print(" Debug \(self.posts)")
        }
    }
}
