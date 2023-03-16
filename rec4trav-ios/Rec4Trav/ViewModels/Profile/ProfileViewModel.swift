//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 10.03.2023.
//

import SwiftUI

class ProfileViewModel : ObservableObject {
    @Published var user : User
    
    init(user: User){
        
        self.user = user
        checIfUserIsFollowed()
    }
    
    func follow(){
        guard let uid = user.id else { return }
        UserService.follow(uid: uid){ _ in
            self.user.isFollowed = true
            
        }
      
        


    }
    func unfollow(){
        guard let uid = user.id else { return }
        UserService.unfollow(uid: uid){ _ in
            self.user.isFollowed = false
            
        }
        
    }
    
    func checIfUserIsFollowed(){
        guard !user.isCurrentUser else { return }
        guard let uid = user.id else { return }
        UserService.checkIfUserIsFollowed(uid: uid){ isFollowed in
            self.user.isFollowed = isFollowed
        }
    }
}
