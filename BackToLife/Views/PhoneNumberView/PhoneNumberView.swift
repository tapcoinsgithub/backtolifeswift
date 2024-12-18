//
//  PhoneNumberView.swift
//  BackToLife
//
//  Created by Eric Viera on 11/29/24.
//

import Foundation
import SwiftUI

struct PhoneNumberView: View {
    @StateObject private var viewModel = PhoneNumberViewModel()
    var body: some View {
        ZStack{
            if viewModel.showConfirmPhoneNumberForm {
                VStack{
                    VStack{
                        Text("Confirm Code")
                            .font(. system(size: UIScreen.main.bounds.width * 0.12))
                            .bold(true)
                            .underline(true)
                        Text("A code has been sent to the phone number you input.")
                    }
                    if #available(iOS 16.0, *) {
                        Form{
                            Section(header: Text("")){
                                TextField("Code", text: $viewModel.phoneNumberCode)
                                if viewModel.isPhoneNumberCodeError{
                                    Label(viewModel.phoneNumberCodeError, systemImage: "xmark.octagon")
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
                                TextField("Code", text: $viewModel.phoneNumberCode)
                                if viewModel.isPhoneNumberCodeError{
                                    Label(viewModel.phoneNumberCodeError, systemImage: "xmark.octagon")
                                        .foregroundColor(Color.red)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                    }
                    CustomSubmitButton(title: "Confirm", action: {viewModel.confirmCodePressed ? nil : viewModel.confirmCodeTask()})
                }
            } // Save Phone Number Below
            else{
                VStack{
                    Text(viewModel.user_phone_number != nil ? "Edit Phone Number" : "Add Phone Number")
                        .font(. system(size: UIScreen.main.bounds.width * 0.12))
                        .bold(true)
                        .underline(true)
                    if #available(iOS 16.0, *) {
                        Form{
                            Section(header: Text("")){
                                TextField("Phone Number", text: $viewModel.phoneNumber)
                                if viewModel.isPhoneNumberError{
                                    Label(viewModel.phoneNumberError, systemImage: "xmark.octagon")
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
                                TextField("Phone Number", text: $viewModel.phoneNumber)
                                if viewModel.isPhoneNumberError{
                                    Label(viewModel.phoneNumberError, systemImage: "xmark.octagon")
                                        .foregroundColor(Color.red)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                    }
                    CustomSubmitButton(title: "Save", action: {viewModel.savePhoneNumberPressed ? nil : viewModel.savePhoneNumberTask()})
                }
            }
            if viewModel.confirmedCode{
                VStack(alignment: .center){
                    Spacer()
                    Text("Confirmed Code.")
                        .font(. system(size: UIScreen.main.bounds.width * 0.04))
                        .bold(true)
                    Text("Phone Number Saved.")
                        .font(. system(size: UIScreen.main.bounds.width * 0.04))
                        .bold(true)
                    Spacer()
                    Button(action: {
                        viewModel.confirmedCode = false
                    }){
                        Text("Close")
                            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                                    .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)
                                    .fill(Color.gray)
                            )
                            .foregroundColor(Color(.black))
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                        .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)
                        .fill(Color(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1))))
                )
            }
        } // ZStack
    }
}
