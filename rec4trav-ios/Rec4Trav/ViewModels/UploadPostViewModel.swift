//
//  UploadPostViewModel.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 10.03.2023.
//

import SwiftUI
import Firebase

class UploadPostViewModel : ObservableObject{
    
    func uploadPost(caption: String, image: UIImage, completion: FirestoreCompletion){
        guard let user = AuthViewModel.shared.currentUser else { return }
        
        ImageUploader.uploadImage(image: image, type: .post){ imageUrl in
            let data = ["caption" : caption,
                        "timestamp" : Timestamp(date: Date()),
                        "likes" : 0,
                        "imageUrl" : imageUrl,
                        "ownerUid" : user.id ?? "",
                        "ownerImageUrl" : user.profileImageUrl,
                        "ownerUsername" : user.username ] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data,completion: completion)
            }
        }
    }

