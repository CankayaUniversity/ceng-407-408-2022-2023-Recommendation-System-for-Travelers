//
//  UploadPostView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 24.02.2023.
//

import SwiftUI

struct UploadPostView: View {
    @State private var selectedImage : UIImage?
    @State var postImage : Image?
    @State var captionText = ""
    @State var isImagePickerPresented = false
    @Binding var tabIndex : Int
    @ObservedObject var viewModel = UploadPostViewModel()
    
    var body: some View {
        
        VStack {
            if postImage == nil{
                Button(action: {
                    isImagePickerPresented.toggle()
                }, label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .clipped()
                    // .foregroundColor(.white)
                        .padding(.top,56)
                }).sheet(isPresented: $isImagePickerPresented,onDismiss: loadImage, content: {
                    ImagePicker(image: $selectedImage)
                })
            }else if let image = postImage{
                HStack(alignment: .top){
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipped()
                    
                    // TextField("Enter your caption...", text: $captionText)
                    TextArea(text: $captionText, placeholder: "Enter a caption.")
                        .frame(height: 200)
                }.padding()
                
                
                HStack(spacing : 16){
                    Button(action: {
                        
                        captionText = ""
                        postImage = nil
                        
                    }, label: {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 172, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }).padding()
                    
                    
                    
                    Button(action: {
                        if let image = selectedImage {
                            
                            viewModel.uploadPost(caption: captionText, image: image){ _ in
                                captionText = ""
                                postImage = nil
                                tabIndex = 0
                            }
                            
                        }
                    }, label: {
                        Text("Share")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 172, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }).padding()
                }
            }
            
            Spacer()
        }
        
        
        
    }
}

extension UploadPostView{
    func loadImage(){
        guard let selectedImage = selectedImage else { return }
        postImage = Image(uiImage: selectedImage)
    }
}

