//
//  SettingsView.swift
//  BackToLife
//
//  Created by Eric Viera on 11/24/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("Settings")
                    .font(. system(size: UIScreen.main.bounds.width * 0.14))
                    .bold(true)
                    .underline(true)
                Spacer()
                NavigationLink(destination:
                                PhoneNumberView().applyBackground()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: BackButtonView())
                               , label: {
                    Text((viewModel.user_phone_number != nil) ? "Edit Phone Number" : "Add Phone Number")
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.07, alignment: .center)
                        .background(Color(.gray))
                        .foregroundColor(Color.black)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                })
                Spacer()
                NavigationLink(destination:
                                EditUsernamePasswordMenuView().applyBackground()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: BackButtonView())
                               , label: {
                    Text("Edit Username and Password")
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.07, alignment: .center)
                        .background(Color(.gray))
                        .foregroundColor(Color.black)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                })
                Spacer()
                NavigationLink(destination: InfoView().applyBackground()
                    .navigationBarBackButtonHidden(true)
                    .applyBackground().applyBackground().navigationBarItems(leading: BackButtonView()), label: {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: UIScreen.main.bounds.width * 0.1))
                        .background(Color(#colorLiteral(red: 0.008568046615, green: 0.2328851819, blue: 1, alpha: 1)))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0.273470372, alpha: 1)))
                        .cornerRadius(UIScreen.main.bounds.width * 0.2)
                })
                Spacer()
                Button("Logout"){
                    viewModel.logoutTask()
                }
                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                .background(Color.gray)
                .foregroundColor(Color.black)
                .cornerRadius(UIScreen.main.bounds.width * 0.02)
                Spacer()
            }
        }
    }
}
