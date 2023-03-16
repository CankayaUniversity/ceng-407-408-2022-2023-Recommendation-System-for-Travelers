//
//  FeedCellViewModel.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 12.03.2023.
//

import Foundation

class FeedCellViewModel: ObservableObject{
    @Published var post: Post
    
    var likeString: String {
        var label = post.likes == 1 ? "like" : "likes"
        if post.likes == 0{
            label = "like"
        }
        return "\(post.likes) \(label)"
    }
    
    init(post: Post){
        self.post = post
        checkIfUserLikedPost()
    }
    func like(){
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        guard let postId = post.id else { return }
        
        COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(postId).setData([:]){ _ in
                
                COLLECTION_POSTS.document(postId).updateData(["likes" : self.post.likes + 1])
                
                self.post.didLike = true
                self.post.likes += 1
            }
        }
        print("Like post")
    }
    func unlike(){
        guard post.likes > 0 else { return }
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        guard let postId = post.id else { return }
        
        COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).delete { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(postId).delete{ _ in
                
                COLLECTION_POSTS.document(postId).updateData(["likes" : self.post.likes - 1])
                
                self.post.didLike = false
                self.post.likes -= 1
                print("Unlike post")
                
            }
        }
    }
    func checkIfUserLikedPost(){
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        guard let postId = post.id else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(postId).getDocument{ snapshot, _ in
         
            guard let didLike = snapshot?.exists else { return }
            self.post.didLike = didLike
        }
    }
}
