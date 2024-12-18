//
//  ContentView.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("viewed_info") var viewed_info:Bool?
    @AppStorage("failed_authorization") var failedAuthorization:Int?
    var body: some View {
        NavigationView{
            if viewed_info ?? false{
                if logged_in_user != nil {
                    HomeView().applyBackground()
                }
                else{
                    if failedAuthorization != nil{
                        FailedAuthorizationView().applyBackground()
                    }
                    else{
                        LoginView().applyBackground()
                    }
                }
            }
            else{
                BeginningInfoView().applyBackground()
            }
        }
    }
}
