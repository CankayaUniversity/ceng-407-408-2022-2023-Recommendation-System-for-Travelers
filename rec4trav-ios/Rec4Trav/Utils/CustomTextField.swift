//
//  CustomTextField.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 5.03.2023.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: Text
    let ImageName: String
    
    var body: some View {
        ZStack(alignment: .leading){
            if text.isEmpty{
                placeholder
                    .foregroundColor(Color(.init(white: 1, alpha: 0.8)))
                    .padding(.leading, 40)
            }
            
            HStack{
                Image(systemName: ImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:20 ,height:20)
                    .foregroundColor(.white)
                
                TextField("", text: $text)
            }
            
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: .constant(""), placeholder: Text("Email"), ImageName: "envelope")
    }
}
