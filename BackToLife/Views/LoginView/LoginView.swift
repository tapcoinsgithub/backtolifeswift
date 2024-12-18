//
//  LoginView.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftUI
import SwiftData

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        ZStack{
            if viewModel.log_pressed{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(.white)))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack{
                    Spacer()
                    Text("BackToLife")
                        .font(. system(size: UIScreen.main.bounds.width * 0.16))
                        .bold(true)
                        .underline(true)
                    if #available(iOS 16.0, *) {
                        Form{
                            Section(header: Text("")){
                                TextField("Username", text: $viewModel.username)
                                if viewModel.isUsernameError{
                                    Label(viewModel.usernameError, systemImage: "xmark.octagon")
                                        .foregroundColor(Color.red)
                                }
                            }
                            SecureField("Password", text: $viewModel.password)
                            if viewModel.isPasswordError{
                                Label(viewModel.passwordError, systemImage: "xmark.octagon")
                                    .foregroundColor(Color.red)
                            }
                            if viewModel.showConfirmPassword{
                                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                if viewModel.isConfirmPasswordError{
                                    Label(viewModel.passwordError, systemImage: "xmark.octagon")
                                        .foregroundColor(Color.red)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                        .scrollContentBackground(.hidden)
                    }
                    else{
                        Form{
                            Section(header: Text("")){
                                TextField("Username", text: $viewModel.username)
                                if viewModel.isUsernameError{
                                    Label(viewModel.usernameError, systemImage: "xmark.octagon")
                                        .foregroundColor(Color.red)
                                }
                            }
                            SecureField("Password", text: $viewModel.password)
                            if viewModel.isPasswordError{
                                Label(viewModel.passwordError, systemImage: "xmark.octagon")
                                    .foregroundColor(Color.red)
                            }
                            if viewModel.showConfirmPassword{
                                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                if viewModel.isConfirmPasswordError{
                                    Label(viewModel.passwordError, systemImage: "xmark.octagon")
                                        .foregroundColor(Color.red)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                    }
                    CustomSubmitButton(title: "Login", action: {viewModel.log_pressed ? nil : viewModel.loginTask()})
                    Spacer()
                    HStack{
                       NavigationLink(destination: ForgotUsernameView().applyBackground()
                           .navigationBarBackButtonHidden(true)
                           .navigationBarItems(leading: BackButtonView()), label: {Text("Forgot username").foregroundColor(Color(#colorLiteral(red: 0.0319102779, green: 0.9777745605, blue: 0.8190543056, alpha: 1))).underline(true)})
                       NavigationLink(destination: ForgotPasswordView().applyBackground()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: BackButtonView()), label: {Text("Forgot password").foregroundColor(Color(#colorLiteral(red: 0.0319102779, green: 0.9777745605, blue: 0.8190543056, alpha: 1))).underline(true)})
                   }
                    Spacer()
                    HStack{
                        Spacer()
                        NavigationLink(destination: InfoView().applyBackground()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: BackButtonView()), label: {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .background(Color(#colorLiteral(red: 0.008568046615, green: 0.2328851819, blue: 1, alpha: 1)))
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0.273470372, alpha: 1)))
                                .cornerRadius(UIScreen.main.bounds.width * 0.2)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    Spacer()
                } // VStack
            }
        }
    }
}
