//
//  HomeView.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{
            if viewModel.loadedUserInfo{
                HStack{
                    Spacer()
                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.05){
                        Spacer()
                        HStack(alignment: .top){
                            Text("BackToLife")
                                .font(. system(size: UIScreen.main.bounds.width * 0.16))
                                .bold(true)
                                .underline(true)
                            Spacer()
                            NavigationLink(destination:
                                            SettingsView().applyBackground()
                                                .navigationBarBackButtonHidden(true)
                                                .navigationBarItems(leading: BackButtonView())
                                           , label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                    .background(Color(.clear))
                                    .foregroundColor(Color(.gray))
                            })
                        }
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.04){
                            Text("\(viewModel.user_name ?? "No Username")")
                                .font(. system(size: UIScreen.main.bounds.width * 0.1))
                                .bold(true)
                                .frame(width: UIScreen.main.bounds.width * 0.64, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                                        .stroke(Color.white, lineWidth: UIScreen.main.bounds.width * 0.01)
                                )
                            VStack(alignment: .leading, spacing: 0){
                                HStack(alignment: .bottom){
                                    Text("Level ")
                                        .font(. system(size: UIScreen.main.bounds.width * 0.04))
                                        .bold(true)
                                    Text("\(Int(viewModel.userLevel))")
                                        .font(. system(size: UIScreen.main.bounds.width * 0.06))
                                        .bold(true)
                                }
                                LevelProgressBar(levelProgressWidth: viewModel.levelProgressWidth)
                            }
                        }
                        VStack(alignment: .center){
                            Text(viewModel.currentlyBlocking ? "Currently Blocking \(viewModel.selectedBlockGroupName ?? "")" : viewModel.selectedBlockGroupName != nil ? "Selected Block Group: \(viewModel.selectedBlockGroupName ?? "")" : "No Block Group Selected.")
                                .font(.system(size: UIScreen.main.bounds.width * 0.058))
                                .bold(true)
                                .lineLimit(1)
                                .underline(true)
                                .foregroundColor(viewModel.noBlockGroupSet ? Color(.red) : Color(.white))
                                .animation(.easeInOut(duration: 0.3), value: viewModel.noBlockGroupSet)
                                .padding(.leading ,UIScreen.main.bounds.width * 0.01)
                            if viewModel.currentlyBlocking == false{
                                NavigationLink(destination:
                                                BlockGroupVew().applyBackground()
                                                    .navigationBarBackButtonHidden(true)
                                                    .navigationBarItems(leading: BackButtonView())
                                               , label: {
                                    Text((viewModel.selectedBlockGroupName != nil ? "Change Block Group" : "Select Block Group") ?? "Select Block Group")
                                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0, green: 1, blue: 0.273470372, alpha: 1)), Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1))]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .foregroundColor(Color.black)
                                        .cornerRadius(UIScreen.main.bounds.width * 0.1)
                                        .shadow(color:Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1)),radius: UIScreen.main.bounds.width * 0.01)
                                })
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.15, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                                .stroke(Color.white, lineWidth: UIScreen.main.bounds.width * 0.01)
                        )
//                        AdBannerView(adUnitID: "ca-app-pub-3940256099942544/2435281174")
//                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                        VStack(alignment: .leading,spacing: 0){
                            if viewModel.currentlyBlocking == false{
                                Slider(value: $viewModel.sliderVal, in: 0...viewModel.max_time, step: 30,label: {Text("Title")}, minimumValueLabel: {Text("0")}, maximumValueLabel: {Text(viewModel.adjustTime(value: viewModel.max_time))})
                                    .frame(height: UIScreen.main.bounds.height * 0.05) // Adjust the slider's height
                                    .padding(.horizontal, UIScreen.main.bounds.height * 0.02)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                                            .stroke(Color.white, lineWidth: UIScreen.main.bounds.width * 0.01)
                                    )
                                    .shadow(color: Color.black.opacity(UIScreen.main.bounds.width * 0.02), radius: UIScreen.main.bounds.width * 0.02, x: 0, y: UIScreen.main.bounds.width * 0.01)
                            }
                            VStack(alignment: .leading, spacing: 0){
                                Text("Block Time:")
                                    .font(. system(size: UIScreen.main.bounds.width * 0.05))
                                    .underline(true)
                                Text(viewModel.currentlyBlocking ? viewModel.displayTime : viewModel.adjustTime(value: viewModel.sliderVal))
                                    .font(. system(size: UIScreen.main.bounds.width * 0.09))
                                    .bold(true)
                                    .lineLimit(1)
                                    .foregroundColor(viewModel.noTimeSet ? Color(.red) : Color(.white))
                                    .animation(.easeInOut(duration: 0.3), value: viewModel.noTimeSet)
                                if viewModel.currentlyBlocking{
                                    TimerProgressBar(timerProgressWidth: viewModel.sendingTimerProgressVal)
                                }
                            }
                            .padding(UIScreen.main.bounds.width * 0.05)
                        }
                        HStack{
                            Spacer()
                            Button(action: {
                                if viewModel.currentlyBlocking{
                                    viewModel.showUnblockOptional()
                                }
                                else{
                                    viewModel.startBlockTask()
                                }
                            }, label: {
                                Text(viewModel.currentlyBlocking ? "Unblock Apps" : "Block Apps")
                                    .font(. system(size: UIScreen.main.bounds.width * 0.05))
                                    .bold(true)
                            })
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6, alignment: .center)
                            .background(viewModel.currentlyBlocking ?
                                        RadialGradient(
                                            gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.2921923399, blue: 0.2997133136, alpha: 1))]),
                                            center: .center,
                                            startRadius: UIScreen.main.bounds.width * 0.1,
                                            endRadius: UIScreen.main.bounds.width * 0.6
                                        ) :
                                        RadialGradient(
                                            gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.3326501846, green: 0.9986339211, blue: 0.4469498992, alpha: 1))]),
                                            center: .center,
                                            startRadius: UIScreen.main.bounds.width * 0.1,
                                            endRadius: UIScreen.main.bounds.width * 0.6
                                        )
                            )
                            .foregroundColor(Color.black)
                            .clipShape(viewModel.currentlyBlocking ? AnyShape(PolygonShape(sides: 8).rotation(Angle(degrees: 22.5))) : AnyShape(Circle())) // Makes the button circular
                            .overlay(
                                (viewModel.currentlyBlocking ? AnyShape(PolygonShape(sides: 8).rotation(Angle(degrees: 22.5))) :AnyShape( Circle())).stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)
                            )
                            .shadow(color: viewModel.currentlyBlocking ? Color(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)) ,radius: UIScreen.main.bounds.width * 0.03)
                            
                            Spacer()
                        }
                        Spacer()
                    } // VStack
                    .padding(.top, 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(edges: .top)
                    Spacer()
                } // HStack
                if viewModel.showEndBlockOptional{
                    PopUpOptionalComponent(
                        descriptionText: viewModel.endBlockOptionalText,
                        buttonOneAction: viewModel.stopBlockTask,
                        buttonOneText: "End Block",
                        buttonTwoAction: viewModel.closeUnblockOptional,
                        buttonTwoText: "Cancel")
                }
            }
            else{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(.white)))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            if viewModel.showStandardError{
                VStack(alignment: .center){
                    Spacer()
                    Text(viewModel.standardErrorMessage)
                        .font(. system(size: UIScreen.main.bounds.width * 0.04))
                        .bold(true)
                    Spacer()
                    Button(action: {
                        viewModel.showStandardError = false
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
                        .fill(Color(#colorLiteral(red: 0.9940627217, green: 0.2769024074, blue: 0, alpha: 1)))
                )
            }
        } // ZStack
        .onReceive(timer, perform: { _ in
            if viewModel.currentlyBlocking{
                viewModel.adjustTimerCount()
            }
        })
        .onAppear(perform: {
            viewModel.getUserInfoTask()
        })
    }
}

//                            (viewModel.currentlyBlocking ? AnyShape(PolygonShape(sides: 8)) : Circle().stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)) // Adds border to the circle
