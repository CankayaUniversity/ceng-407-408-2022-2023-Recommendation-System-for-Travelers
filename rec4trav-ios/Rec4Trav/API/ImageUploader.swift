//
//  ImageUploader.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 16.03.2023.
//


import UIKit
import FirebaseStorage
import Firebase

enum UploadType{
    case profile
    case post
        
    var filePath: StorageReference {
        let filename = NSUUID().uuidString
        switch self{
        case .profile: return Storage.storage().reference(withPath: "/profile_images/\(filename)")
        case .post: return Storage.storage().reference(withPath: "/profile_images/\(filename)")
        }
    }
}

struct ImageUploader{
    static func uploadImage(image: UIImage,type: UploadType,completion: @escaping(String) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let ref = type.filePath
        
        ref.putData(imageData, metadata: nil){ _, error in
            if let error = error{
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            print("Image succesfully uploaded")
            
            ref.downloadURL{ url, _ in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
                
            }
            
        }
    }
}
