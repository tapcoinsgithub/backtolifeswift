//
//  InfoView.swift
//  BackToLife
//
//  Created by Eric Viera on 12/5/24.
//

import Foundation
import SwiftUI

struct InfoView: View {
    
    @StateObject private var viewModel = EditUsernameViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                    Spacer()
                    Text("About BackToLife")
                        .font(.system(size: UIScreen.main.bounds.width * 0.1))
                        .bold(true)
                        .underline()
                    ScrollView{
                        VStack{
                            InfoViewCardComponent(heading: "Heading Here", pages: "1/3", description: "Description text here: is a high-speed one vs one game where you have 15 seconds to tap as many coins as you can before your oppenent! Compete against friends in to see whos better or rank up by beating players in your rank in.")
                            InfoViewCardComponent(heading: "Heading Here", pages: "2/3", description: "Description text here: is a high-speed one vs one game where you have 15 seconds to tap as many coins as you can before your oppenent! Compete against friends in to see whos better or rank up by beating players in your rank in.")
                            InfoViewCardComponent(heading: "Heading Here", pages: "3/3", description: "Description text here: is a high-speed one vs one game where you have 15 seconds to tap as many coins as you can before your oppenent! Compete against friends in to see whos better or rank up by beating players in your rank in.")
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
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
                        }
                    }
                    Spacer()
                } //VStack
                Spacer()
            } //HStack
        }
    }
}
