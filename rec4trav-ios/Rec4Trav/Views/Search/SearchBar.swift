//
//  SearchBar.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 3.03.2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(8)
                .padding(.horizontal,24)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
                .overlay(
                    HStack{
                        Image(systemName: "magnifyingglass")
                    
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                            .padding(.leading,8)
                        Spacer()
                    }
                ).onTapGesture {
                    isEditing = true
                }
            
            if isEditing{
                Button(action: {
                    isEditing=false
                    text = ""
                    UIApplication.shared.endEditing()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                }).padding(.trailing,8)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("Search..."), isEditing: .constant(true))
    }
}
