//
//  EditUsernamePasswordMenuView.swift
//  BackToLife
//
//  Created by Eric Viera on 12/2/24.
//

import Foundation
import SwiftUI

struct EditUsernamePasswordMenuView: View {
    
    @StateObject private var viewModel = EditUsernamePasswordMenuViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                Spacer()
                Spacer()
                NavigationLink(destination:
                                EditUsernameView().applyBackground()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: BackButtonView())
                               , label: {
                    Text("Edit Username")
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.07, alignment: .center)
                        .background(Color(.gray))
                        .foregroundColor(Color.black)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                })
                Spacer()
                NavigationLink(destination:
                                EditPasswordView().applyBackground()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: BackButtonView())
                               , label: {
                    Text("Edit Password")
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.07, alignment: .center)
                        .background(Color(.gray))
                        .foregroundColor(Color.black)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                })
                Spacer()
                Spacer()
            } //VStack
        } //ZStack
    }
}
