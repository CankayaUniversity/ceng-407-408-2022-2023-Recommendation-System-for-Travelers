//
//  CommentsView.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 20.03.2023.
//

import SwiftUI

struct CommentsView: View {
    @ObservedObject var viewModel : CommentViewModel
    init(post: Post){
        self.viewModel = CommentViewModel(post: post)
    }
    
    @State var commentText = ""
        
        
    var body: some View {
        VStack{
            //Comment Cells
            ScrollView(showsIndicators: false){
                LazyVStack(alignment: .leading){
                    ForEach(viewModel.comments){comment in
                        CommentsCell(comment: comment)
                            .padding(.horizontal,1)
                            .padding(.vertical,8)
                    }
                }
            }.padding(.top)
            
            //Input View
            CustomInputView(inputText: $commentText, action: uploadComment)
        }
    }
    
    func uploadComment(){
        viewModel.uploadComment(commentText: commentText)
        commentText = ""
    }
}


