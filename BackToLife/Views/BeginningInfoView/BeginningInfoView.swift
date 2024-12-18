//
//  BeginningInfoView.swift
//  BackToLife
//
//  Created by Eric Viera on 12/9/24.
//

import Foundation
import SwiftUI

struct NextPrevButton:View {
    var isNext:Bool
    var model:BeginningInfoViewModel
    var body: some View {
        Button(action: {
            if isNext{
                model.pageNumber += 1
            }
            else{
                model.pageNumber -= 1
            }
        }, label: {
            if isNext{
                Image(systemName: "arrowshape.right.fill") // You can use any image or view here
                    .foregroundColor(Color(.white)
                    ) // Change the color of the back button
                        .font(.title)
            }
            else{
                Image(systemName: "arrowshape.left.fill") // You can use any image or view here
                    .foregroundColor(Color(.white)
                    ) // Change the color of the back button
                        .font(.title)
            }
        })
    }
}

struct BeginningInfoView: View {
    @AppStorage("viewed_info") var viewed_info:Bool?
    @StateObject private var viewModel = BeginningInfoViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                    Spacer()
                    if viewModel.pageNumber == 1{
                        InfoViewCardComponent(heading: "Heading Here", pages: "1/3", description: "Description text here: is a high-speed one vs one game where you have 15 seconds to tap as many coins as you can before your oppenent! Compete against friends in to see whos better or rank up by beating players in your rank in.")
                        HStack{
                            Spacer()
                            NextPrevButton(isNext: true, model: viewModel)
                        }
                        Spacer()
                    }
                    else if viewModel.pageNumber == 2{
                        InfoViewCardComponent(heading: "Heading Here", pages: "2/3", description: "Description text here: is a high-speed one vs one game where you have 15 seconds to tap as many coins as you can before your oppenent! Compete against friends in to see whos better or rank up by beating players in your rank in.")
                        HStack{
                            NextPrevButton(isNext: false, model: viewModel)
                            Spacer()
                            NextPrevButton(isNext: true, model: viewModel)
                        }
                        Spacer()
                    }
                    else if viewModel.pageNumber == 3{
                        InfoViewCardComponent(heading: "Heading Here", pages: "3/3", description: "Description text here: is a high-speed one vs one game where you have 15 seconds to tap as many coins as you can before your oppenent! Compete against friends in to see whos better or rank up by beating players in your rank in.")
                        HStack{
                            NextPrevButton(isNext: false, model: viewModel)
                            Spacer()
                            Button(action: {
                                self.viewed_info = true
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
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
