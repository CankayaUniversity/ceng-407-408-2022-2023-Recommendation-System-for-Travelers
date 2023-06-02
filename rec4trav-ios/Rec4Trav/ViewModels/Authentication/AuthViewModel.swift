//
//  AuthViewModel.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 6.03.2023.
//

import SwiftUI
import Firebase

import UIKit

class AuthViewModel : ObservableObject {
    @Published var userSession : Firebase.User?
    @Published var currentUser : User?
    @Published var loginStatusMessage = ""

    @Published var registerStatusMessage = ""

    static let shared = AuthViewModel()
    
    init(){
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email , password: password){result, error in
            if let error = error {
                print("DEBUG: Login failed \(error.localizedDescription)")
                self.loginStatusMessage = "Failed to login user: \(error.localizedDescription)"
                
                return
            }
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func emptyStatus(){
        self.loginStatusMessage = ""
        self.registerStatusMessage = ""
    }
    
    func register(withEmail email: String, password: String, image: UIImage?, fullname: String, username: String){
        
        guard let image = image else { return }
        
        ImageUploader.uploadImage(image: image, type: .profile){ imageUrl in
            Auth.auth().createUser(withEmail: email, password: password){ result, error in
                    
                if let error = error{
                    print(error.localizedDescription)
                    self.registerStatusMessage = "Failed to register user: \(error)"

                    return
                }
                
                guard let user = result?.user else { return }

                print("Succesfully registered the user")
        
                
                let data = ["email" : email
                            ,"username" : username
                            ,"fullname" : fullname
                            , "profileImageUrl" : imageUrl
                            , "uid" : user.uid]
                
                COLLECTION_USERS.document(user.uid).setData(data) { _ in
                    print("Succesfully uploaded user data")

                    self.userSession = user
                    self.fetchUser()
                }
                
            }
        }

    }
    func signOut(){
        self.userSession = nil
        
        try? Auth.auth().signOut()
    }
    func fetchUser(){
        guard let uid = userSession?.uid else { return }
         
        COLLECTION_USERS.document(uid).getDocument{ snapshot, _ in
     
            guard let user = try? snapshot?.data(as: User.self) else { return }
            self.currentUser =  user
                
        }
    }
    func resetPassword(){
        
    }
}
