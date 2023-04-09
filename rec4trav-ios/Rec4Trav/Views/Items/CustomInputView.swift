//
//  CustomInputView.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 20.03.2023.
//

import SwiftUI

struct CustomInputView: View {
    @Binding var inputText : String
    
    var action : () -> Void
    var body: some View {
        VStack {
            
            //Divider
            Rectangle()
                .foregroundColor(Color(.separator))
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
                .padding(.bottom,8)
            
            
            
            
            //Hstack of send button and text field
            
            HStack{
                TextField("Comment...", text: $inputText)
                    .textFieldStyle(.plain)
                    .frame(minHeight: 30)
                
                Button(action: action) {
                    Text("Send")
                        .bold()
                        .foregroundColor(.black)
                }
            }
            .padding(.bottom,8)
            .padding(.horizontal)
        }
        
    }
}
