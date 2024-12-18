//
//  ForgotPasswordView.swift
//  BackToLife
//
//  Created by Eric Viera on 12/2/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {

    @StateObject private var viewModel = ForgotPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack{
            if viewModel.send_pressed{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1))))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                    Spacer()
                    if viewModel.successfully_sent{
                        Text("Input the code and your new password.")
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .padding()
                        Rectangle()
                            .fill(Color(.red))
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        if #available(iOS 16.0, *) {
                            Form{
                                Section(header: Text("")){
                                    if viewModel.is_error{
                                        Label(viewModel.error, systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                    TextField("Code", text: $viewModel.code)
                                    SecureField("Password", text: $viewModel.password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                                    .foregroundColor(Color(.red))
                                    }
                                    if viewModel.is_password_error{
                                        Label("Password can't be blank.", systemImage: "xmark.octagon")
                                                    .foregroundColor(Color(.red))
                                    }
                                    SecureField("Confirm Password", text: $viewModel.c_password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                }
                            }.scrollContentBackground(.hidden)
                        }
                        else{
                            Form{
                                Section(header: Text("")){
                                    if viewModel.is_error{
                                        Label(viewModel.error, systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                    TextField("Code", text: $viewModel.code)
                                    SecureField("Password", text: $viewModel.password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                    if viewModel.is_password_error{
                                        Label("Password can't be blank.", systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                    SecureField("Confirm Password", text: $viewModel.c_password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                }
                            }
                        }
                        Spacer()
                        if viewModel.submitted{
                            Label("New password saved successfully!", systemImage: "checkmark.seal.fill")
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)))
                        }
                        else{
                            Label("Message sent!", systemImage: "checkmark.circle.fill")
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)))
                                .padding()
                            Text("If you did not see a message please press, send again")
                                .foregroundColor(Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1)))
//                            Text("send again.")
//                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                        }
                        Spacer()
                        CustomSubmitButton(title: "Submit", action: {viewModel.send_pressed ? nil : viewModel.submitTask()})
                        CustomSubmitButton(title: "Send Again", action: {viewModel.send_pressed ? nil : viewModel.sendCodeTask()})
                    }
                    else{
                        Spacer()
                        Text("Input the phone number associated with your account and we will send you a code to reset your password.")
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .padding()
                        Rectangle()
                            .fill(Color(.red))
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        if #available(iOS 16.0, *) {
                            Form{
                                Section(header: Text("")){
                                    TextField("Phone number", text: $viewModel.phone_number)
                                    if viewModel.is_phone_error{
                                        Label("Invalid phone number", systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }else{
                            Form{
                                Section(header: Text("")){
                                    TextField("Phone number", text: $viewModel.phone_number)
                                    if viewModel.is_phone_error{
                                        Label("Invalid phone number", systemImage: "xmark.octagon")
                                            .foregroundColor(Color(.red))
                                    }
                                }
                            }
                        }
                        Spacer()
                        if viewModel.is_error {
                            Label(viewModel.error, systemImage: "xmark.octagon")
                                .foregroundColor(Color(.red))
                        }
                        Spacer()
                        CustomSubmitButton(title: "Send", action: {viewModel.send_pressed ? nil : viewModel.sendCodeTask()})
                    }
                    Spacer()
                } //VStack
            }
            
        } // ZStack
    }
}
