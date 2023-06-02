//
//  RegisterView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 4.03.2023.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var repassword = ""
    @State private var selectedImage : UIImage?
    @State private var profileImage : Image?
    @State var isImagePickerPresented = false
    @State private var showAlert = false

  
    @EnvironmentObject var viewModel : AuthViewModel


    @Environment (\.presentationMode) var mode
    
   
    var body: some View {
        
     
            NavigationView{
                    ZStack {
                        
                        LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                        
                        VStack{
                            
                       
                            ZStack{
                                
                            
                                
                                //Image Picker
                                
                                if let profileImage = profileImage{
                                    
                                    profileImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 130, height: 130)
                                        .clipped()
                                        
                                        .clipShape(Circle())
                                        .padding(.bottom,10)
                                     
                                    /*   .clipped()
                                     .padding(.bottom,10)*/
                                }else{
                                    Button(action: {
                                        isImagePickerPresented.toggle()
                                    }, label: {
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .resizable()
                                            .renderingMode(.template)
                                            .scaledToFit()
                                            .frame(width: 130, height: 130)
                                            .clipped()
                                            .padding(.bottom,10)
                                            .foregroundColor(.white)
                                        //  .padding(.top,56)
                                    }).sheet(isPresented: $isImagePickerPresented,onDismiss: loadImage, content: {
                                        ImagePicker(image: $selectedImage)
                                    })
                                }
                            }
                            
                            //Email field
                            VStack (spacing: 20){
                                //Username field
                                CustomTextField(text: $username, placeholder: Text("Username"), ImageName: "person")
                                
                                    .padding()
                                    .background(Color(.init(white: 1, alpha: 0.15)))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                .padding(.horizontal,32)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                
                                //Fullname field
                                CustomTextField(text: $fullname, placeholder: Text("Full Name"), ImageName: "person")
                                
                                    .padding()
                                    .background(Color(.init(white: 1, alpha: 0.15)))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                .padding(.horizontal,32)
                                .autocorrectionDisabled(true)
                                
                                
                                //Email field
                                CustomTextField(text: $email, placeholder: Text("Email"), ImageName: "envelope")
                                
                                    .padding()
                                    .background(Color(.init(white: 1, alpha: 0.15)))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                .padding(.horizontal,32)
                               .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)

                            //Password field
                            CustomSecureField(text: $password, placeholder: Text("Password"))
                            
                                .padding()
                                .background(Color(.init(white: 1, alpha: 0.15)))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .padding(.horizontal,32)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                    
                                
                                //Repassword Field
                                CustomSecureField(text: $repassword, placeholder: Text("Re Password"))
                                
                                    .padding()
                                    .background(Color(.init(white: 1, alpha: 0.15)))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .padding(.horizontal,32)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .padding(.bottom,30)
                               
                            }
                            
                        
                           if password == repassword{
                               Button(action: {
                                   viewModel.register(withEmail: email, password: password, image: selectedImage, fullname: fullname, username: username)
                                   
                                   viewModel.emptyStatus()
                                   
                               }, label: {
                                   Text("Sign Up")
                                       .font(.headline)
                                       .padding()
                                       .foregroundColor(.white)
                                       .frame(width: 360)
                                       .background(Color.purple)
                                       .clipShape(Capsule())
                                       
                               }).padding(.bottom,100)

                           }else{
                               Button(action: {
                                   viewModel.register(withEmail: email, password: password, image: selectedImage, fullname: fullname, username: username)
                                   
                                   viewModel.emptyStatus()
                               }, label: {
                                   Text("Passwords Doesn't Match")
                                       .font(.headline)
                                       .padding()
                                       .foregroundColor(.white)
                                       .frame(width: 360)
                                       .background(Color.gray)
                                       .clipShape(Capsule())
                                       
                               })
                               .disabled(true)
                               .padding(.bottom,100)
                               

                           }
                            
                        
                              Button(action: {
                                  mode.wrappedValue.dismiss()
                              }, label: {
                                  HStack{
                                  Text("Already have an account?")
                                      .foregroundColor(.white)
                                      .font(.system(size: 14))
                                  Text("Sign In!")
                                      .foregroundColor(.white)
                                      .bold()
                                      .font(.system(size: 14))
                                  }
                              })//.padding(.bottom,10)
                            

                            
                        }       .alert(isPresented: .constant(!viewModel.registerStatusMessage.isEmpty)) {
                            Alert(title: Text("Login Status"),
                                  message: Text(viewModel.registerStatusMessage),
                                  dismissButton: .default(Text("Okay")))
                     
                  
                        }
                        
                         
                            //Forgot Password Field
                          /*  HStack{
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    Text("Forgot Password?")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14,weight: .semibold))
                                })
                            }
                            .padding(.trailing,32)
                            .padding(.top,10)
                           */
                            //Sign in
                      
                 
                            //Already have an account
                            
                           
                    
                           
                          
                            
                        }
                            
                      
                    }
                        
            
        }
    }

                                     
                                     
    extension RegisterView{
        func loadImage(){
            guard let selectedImage = selectedImage else { return }
                profileImage = Image(uiImage: selectedImage)
                        }
                    }

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
