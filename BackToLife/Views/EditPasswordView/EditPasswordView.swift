//
//  EditPasswordView.swift
//  BackToLife
//
//  Created by Eric Viera on 12/2/24.
//

import Foundation
import SwiftUI

struct EditPasswordView: View {
    
    @StateObject private var viewModel = EditPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            if viewModel.buttonPressed{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1))))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                if viewModel.showNewPasswordForm {
                    if viewModel.savedNewPassword{
                        VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            Spacer()
                            Text("Successfully Saved New Password.")
                                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                .bold(true)
                                .padding()
                            Spacer()
                        }
                    }
                    else{
                        VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            Spacer()
                            VStack{
                                Text("Input your new password.")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .padding()
                            }
                            Rectangle()
                                .fill(Color(.red))
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                            if #available(iOS 16.0, *){
                                Form{
                                    SecureField("Password", text: $viewModel.newPassword)
                                    if viewModel.isNewPasswordError{
                                        Label(viewModel.newPasswordError, systemImage: "xmark.octagon")
                                            .foregroundColor(Color.red)
                                    }
                                    SecureField("Confirm Password", text: $viewModel.confirmNewPassword)
                                    if viewModel.isNewPasswordError{
                                        Label(viewModel.newPasswordError, systemImage: "xmark.octagon")
                                            .foregroundColor(Color.red)
                                    }
                                }
                                .scrollContentBackground(.hidden)
                            }
                            else{
                                Form{
                                    SecureField("Password", text: $viewModel.newPassword)
                                    if viewModel.isNewPasswordError{
                                        Label(viewModel.newPasswordError, systemImage: "xmark.octagon")
                                            .foregroundColor(Color.red)
                                    }
                                    SecureField("Confirm Password", text: $viewModel.confirmNewPassword)
                                    if viewModel.isNewPasswordError{
                                        Label(viewModel.newPasswordError, systemImage: "xmark.octagon")
                                            .foregroundColor(Color.red)
                                    }
                                }
                            }
                            CustomSubmitButton(title: "Save", action: {viewModel.buttonPressed ? nil : viewModel.saveNewPasswordTask()})
                            Spacer()
                        } //VStack
                    }
                }
                else{
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                        Spacer()
                        VStack{
                            Text("Confirm your password to change your password.")
                                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                .padding()
                        }
                        Rectangle()
                            .fill(Color(.red))
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        if #available(iOS 16.0, *){
                            Form{
                                Section(header: Text("")){
                                    SecureField("Password", text: $viewModel.password)
                                    if viewModel.isPasswordError{
                                        Label(viewModel.passwordError, systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                        else{
                            Form{
                                Section(header: Text("")){
                                    SecureField("Password", text: $viewModel.password)
                                    if viewModel.isPasswordError{
                                        Label(viewModel.passwordError, systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                }
                            }
                        }
                        CustomSubmitButton(title: "Confirm", action: {viewModel.buttonPressed ? nil : viewModel.confirmPasswordTask()})
                        Spacer()
                    } //VStack
                }
            }
        }
    }
}
