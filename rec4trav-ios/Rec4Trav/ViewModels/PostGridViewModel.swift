//
//  PostGridViewModel.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 12.03.2023.
//

import SwiftUI

enum PostGridConfiguration{
    case explore
    case profile(String)
}

class PostGridViewModel: ObservableObject{
    @Published var posts = [Post]()
    
    let config : PostGridConfiguration
    init(config : PostGridConfiguration){
        
        self.config = config
        
        fetchPosts(forConfig: config)
    }
    
    func fetchPosts(forConfig config: PostGridConfiguration){
        switch config {
        case .explore:
            fetchExplorePagePosts()
        case .profile(let uid):
            fetchProfilePagePosts(forUid: uid)
        }
    }
    func fetchExplorePagePosts(){
        COLLECTION_POSTS.getDocuments{ snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.posts = documents.compactMap({ try? $0.data(as: Post.self)})
            
        }
    }
    func fetchProfilePagePosts(forUid uid: String){
        COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments{ snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.posts = documents.compactMap({ try? $0.data(as: Post.self)})
            
        }
    }
}
