//
//  LoginView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 4.03.2023.
//

import SwiftUI
import Firebase



struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false

    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    Image("logo")
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width:220 ,height: 100)
                        .padding(.top,100)
                        .padding(.bottom,20)
                      
                    
                    //Email field
                    VStack (spacing: 20){
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
                        
                    }
                    //Forgot Password Field
                    HStack{
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
                    //Sign in
                    
                    Button(action: {
                        viewModel.login(withEmail: email, password: password)
                        
                        viewModel.emptyStatus()
                    }, label: {
                        Text("Sign In")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 360)
                            .background(Color.purple)
                            .clipShape(Capsule())
                            
                    }).padding(.top)
                    //Already have an account
                    
              
                    Spacer()
                    
                    NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true), label: {
                        HStack{
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        Text("Sign Up!")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 14))
                        }
                    }) .padding(.bottom,20)
                 
                     
                   
              
                
                }
                .alert(isPresented: .constant(!viewModel.loginStatusMessage.isEmpty)) {
                           Alert(title: Text("Login Status"),
                                 message: Text(viewModel.loginStatusMessage),
                                 dismissButton: .default(Text("Okay")))
                    
                 
                       }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
