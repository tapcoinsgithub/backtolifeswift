//
//  FailedAuthorizationView.swift
//  BackToLife
//
//  Created by Eric Viera on 12/9/24.
//

import Foundation
import SwiftUI
// TODO:
// Handle displaying Error screen on Content view based on nil session and not nil failedAuthorization
// handle displaying specific error based on failed authorization val
struct FailedAuthorizationView: View {
    @AppStorage("failed_authorization") var failedAuthorization:Int?
    var body: some View {
        ZStack{
            if failedAuthorization == 1{
                HStack{
                    Spacer()
                    VStack{
                        // Must allow access inorder to use app, please login again and allow access
                        Spacer()
                        Text("User must allow access in order to use the app. Please login again and press 'Continue' to allow BackToLife to access your phones Screen Time settings, in order to access all of the functionality of the app.")
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)))
                            .font(. system(size: UIScreen.main.bounds.width * 0.06))
                            .bold(true)
                            .underline(true)
                        Button(action: {
                            self.failedAuthorization = nil
                        }, label: {
                            Text("I understand.")
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                                        .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0, green: 1, blue: 0.273470372, alpha: 1)), Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1))]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                )
                                .foregroundColor(Color(.black))
                        })
                        Spacer()
                    }
                    Spacer()
                }
            }
            else if failedAuthorization == 2{
                HStack{
                    Spacer()
                    VStack{
                        //  Display error on login page saying something went wrong and must create new account
                        Spacer()
                        Text("Something went wrong. Please create a new account and try again. Be sure to press 'Continue' to allow BackToLife to access your phones Screen Time settings, in order to access all the funnctionality of the app.")
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)))
                            .font(. system(size: UIScreen.main.bounds.width * 0.06))
                            .bold(true)
                            .underline(true)
                        Button(action: {
                            self.failedAuthorization = nil
                        }, label: {
                            Text("I understand.")
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                                        .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0, green: 1, blue: 0.273470372, alpha: 1)), Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1))]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                )
                                .foregroundColor(Color(.black))
                        })
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}
