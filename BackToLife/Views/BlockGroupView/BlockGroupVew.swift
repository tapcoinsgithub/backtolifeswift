//
//  BlockGroupVew.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings

struct BlockGroupVew: View {
    @StateObject private var viewModel = BlockGroupViewModel()
    @State private var isPickerPresented = false
    @State private var selection = FamilyActivitySelection()
    let store = ManagedSettingsStore()
    var body: some View {
        ZStack{
            Color(.clear)
                .ignoresSafeArea()
            if viewModel.isLoadingBlockGroups{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(.white)))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack{
                    Spacer()
                    Text("Block Groups")
                        .font(. system(size: UIScreen.main.bounds.width * 0.1))
                        .bold(true)
                    HStack{
                        Spacer()
                        NavigationLink(destination:
                                        SetBlockGroupView(blockGroupName: "", editView: false).applyBackground()
                                            .navigationBarBackButtonHidden(true)
                                            .navigationBarItems(leading: BackButtonView()), label: {
                            HStack(){
                                Text(viewModel.allBlockGroups.count <= 0 ? "Create a Block Group" : "Add Block Group")
                                    .foregroundColor(Color.black)
                                Image(systemName: "plus.app")
                                    .foregroundColor(Color.black)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                            .background(RadialGradient(
                                gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.3326501846, green: 0.9986339211, blue: 0.4469498992, alpha: 1))]),
                                center: .center,
                                startRadius: UIScreen.main.bounds.width * 0.1,
                                endRadius: UIScreen.main.bounds.width * 0.6
                            ))
                            .cornerRadius(UIScreen.main.bounds.width * 0.02)
                            .overlay(
                                RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.02)
                                    .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.005)
                            )
                            .shadow(color:Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)),radius: UIScreen.main.bounds.width * 0.01)
                        })
                    }
                    ScrollView{
                        VStack{
                            if viewModel.allBlockGroups.count <= 0{
                                Text("No Block Groups yet.")
                            }
                            else{
                                ForEach(Array(viewModel.allBlockGroups), id: \.blockGroupName) { group in
                                    Button(action: {
                                        viewModel.selectBlockGroup(blockGroup: group)
                                    }) {
                                        HStack{
                                            Spacer()
                                            Text(group.blockGroupName)
                                            Spacer()
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                                    .foregroundColor(viewModel.selectedBlockGroupName == group.blockGroupName ? .black : .white)
                                    .background(viewModel.selectedBlockGroupName == group.blockGroupName ?
                                        RadialGradient(
                                            gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.3326501846, green: 0.9986339211, blue: 0.4469498992, alpha: 1))]),
                                            center: .center,
                                            startRadius: UIScreen.main.bounds.width * 0.1,
                                            endRadius: UIScreen.main.bounds.width * 0.6
                                        ):
                                        RadialGradient(
                                            gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5535025001, green: 0.04145926237, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1))]),
                                            center: .center,
                                            startRadius: UIScreen.main.bounds.width * 0.1,
                                            endRadius: UIScreen.main.bounds.width * 0.6
                                        ))
                                    .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.02)
                                            .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.005)
                                    )
                                    .shadow(color:viewModel.selectedBlockGroupName == group.blockGroupName ? Color(#colorLiteral(red: 0.3326501846, green: 0.9986339211, blue: 0.4469498992, alpha: 1)) : Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1)),radius: UIScreen.main.bounds.width * 0.01)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.85 ,height: UIScreen.main.bounds.height * 0.65, alignment: .top)
                    }
                    Spacer()
                } // VStack
            } // Else Block
            if viewModel.selectedBlockGroupName != nil{
                HStack{
                    NavigationLink(
                        destination:
                            SetBlockGroupView(blockGroupName: viewModel.selectedBlockGroupName ?? "None", editView: true).applyBackground()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: BackButtonView()),
                        label: {
                            Image(systemName: "pencil")
                                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.15, alignment: .center)
                                .background(RadialGradient(
                                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.3326501846, green: 0.9986339211, blue: 0.4469498992, alpha: 1))]),
                                    center: .center,
                                    startRadius: UIScreen.main.bounds.width * 0.1,
                                    endRadius: UIScreen.main.bounds.width * 0.6
                                ))
                                .foregroundColor(.black)
                                .clipShape(AnyShape(Circle())) // Makes the button circular
                                .overlay(
                                    (AnyShape( Circle())).stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.008)
                                )
                                .shadow(color: Color(#colorLiteral(red: 0.3326501846, green: 0.9986339211, blue: 0.4469498992, alpha: 1)),radius: UIScreen.main.bounds.width * 0.01)
                    })
                    Spacer()
                    Button(action: {
                        if viewModel.showDeleteBlockGroupOptional != true{
                            viewModel.showDeleteBlockGroupOptional = true
                            viewModel.selectedBlockGroupToDelete = viewModel.selectedBlockGroupName ?? "None"
                        }
                    }){
                        Image(systemName: "trash")
                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.15, alignment: .center)
                    .background(Color(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)))
                    .foregroundColor(.black)
                    .clipShape(AnyShape(Circle())) // Makes the button circular
                    .overlay(
                        (AnyShape( Circle())).stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.008)
                    )
                    .shadow(color: Color(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)),radius: UIScreen.main.bounds.width * 0.01)
                }
                .frame(width: UIScreen.main.bounds.width * 0.95 ,height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                .offset(y:UIScreen.main.bounds.height * 0.35)
            }
            
            if viewModel.showDeleteBlockGroupOptional {
                PopUpOptionalComponent(
                    descriptionText: "Are you sure you want to delete this BlockGroup?",
                    buttonOneAction: viewModel.deleteBlockGroupTask,
                    buttonOneText: "Delete",
                    buttonTwoAction: viewModel.closeDeleteBlockGroupOptional,
                    buttonTwoText: "Cancel")
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
        .onAppear(perform: {
            viewModel.getBlockGroupsTask()
        })
    }
}
