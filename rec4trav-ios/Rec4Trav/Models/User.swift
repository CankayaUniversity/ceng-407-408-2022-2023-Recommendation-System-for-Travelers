//
//  Post.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 12.03.2023.
//



import FirebaseFirestoreSwift

struct User : Identifiable,Decodable {
    let username: String
    let email: String
    let profileImageUrl: String
    let uid : String
    let fullname : String
    
    @DocumentID var id: String?
    
    var isFollowed : Bool? = false
    

    var isCurrentUser: Bool { return AuthViewModel.shared.userSession?.uid == id }
    
    
}
