//
//  ForgotUsernameView.swift
//  BackToLife
//
//  Created by Eric Viera on 12/2/24.
//

import Foundation
import SwiftUI

struct ForgotUsernameView: View {

    @StateObject private var viewModel = ForgotUsernameViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                Spacer()
                VStack{
                    Text("Input the phone number associated with your account and we will send you your username.")
                        .font(.system(size: UIScreen.main.bounds.width * 0.05))
                        .padding()
                }
                Rectangle()
                    .fill(Color(.red))
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                if #available(iOS 16.0, *){
                    Form{
                        Section(header: Text("")){
                            TextField("Phone number", text: $viewModel.phone_number)
                            if viewModel.is_phone_error{
                                Label(viewModel.phoneError, systemImage: "xmark.octagon")
                                    .foregroundColor(Color(.red))
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                else{
                    Form{
                        Section(header: Text("")){
                            TextField("Phone number", text: $viewModel.phone_number)
                            if viewModel.is_phone_error{
                                Label(viewModel.phoneError, systemImage: "xmark.octagon")
                                    .foregroundColor(Color(.red))
                            }
                        }
                    }
                }
                
                if viewModel.successfully_sent{
                    Spacer()
                    Label("Message sent!", systemImage: "checkmark.circle.fill")
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)))
                    Text("If you did not see a message please input your phone number again and press send.")
                        .foregroundColor(Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1)))
                        .padding()
                    Spacer()
                }
                CustomSubmitButton(title: "Send", action: {viewModel.send_pressed ? nil : viewModel.sendUsernameTask()})
                Spacer()
            } //VStack

            if viewModel.send_pressed{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1))))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
        } // ZStack
    }

}
