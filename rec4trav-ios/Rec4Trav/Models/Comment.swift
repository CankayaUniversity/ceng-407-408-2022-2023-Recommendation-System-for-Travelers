//
//  Comment.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 20.03.2023.
//

import FirebaseFirestoreSwift
import Firebase

struct Comment: Identifiable, Decodable{
    @DocumentID var id: String?
    let username: String
    let postOwnerUid: String
    let profileImageUrl: String
    let commentText: String
    let timestamp: Timestamp
    let uid: String

    
}
