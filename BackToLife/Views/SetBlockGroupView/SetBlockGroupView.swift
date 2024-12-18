//
//  SetBlockGroupView.swift
//  BackToLife
//
//  Created by Eric Viera on 11/17/24.
//

import Foundation
import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings

struct SetBlockGroupView: View {
    @StateObject private var viewModel = SetBlockGroupViewModel()
    
    var blockGroupName:String
    var editView:Bool
    
    init(blockGroupName:String, editView: Bool) {
        self.blockGroupName = blockGroupName
        self.editView = editView
    }
    
    var body: some View {
        ZStack{
            if viewModel.setBlockGroupPressed{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(.white)))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
                    Spacer()
                    Text(editView ? "Edit Block Group" : "Create Block Group")
                        .font(. system(size: UIScreen.main.bounds.width * 0.1))
                        .bold(true)
                    Form{
                        Section(header: Text("")){
                            TextField(editView ? blockGroupName : "Block group name", text: $viewModel.blockGroupName)
                            if viewModel.is_error{
                                Label(viewModel.error, systemImage: "xmark.octagon")
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.2, alignment: .bottom)
                    .scrollContentBackground(.hidden)
                    Button(action: {
                        viewModel.isPickerPresented = true
                    }) {
                        Label(editView ? "Update Apps to Block" : "Select Apps to Block", systemImage: "plus")
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                    .foregroundColor(.black)
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
                    .shadow(color: Color(#colorLiteral(red: 0.3326501846, green: 0.9986339211, blue: 0.4469498992, alpha: 1)),radius: UIScreen.main.bounds.width * 0.02)
                    .familyActivityPicker(isPresented: $viewModel.isPickerPresented, selection: $viewModel.selection)
                    .onChange(of: viewModel.selection) { newSelection in
                        viewModel.saveSelection(selection: newSelection)
                    }
                    if viewModel.blockGroupSaved {
                        Text(editView ? "Block Group Updated!" : "Block Group Saved!")
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                            .background(Color.green)
                            .foregroundColor(Color.black)
                            .cornerRadius(UIScreen.main.bounds.width * 0.02)
                    }
                    if viewModel.appTokenTempNames.count > 0{
                        Text("\(viewModel.appTokenTempNames.count) Apps Selected.")
                            .font(. system(size: UIScreen.main.bounds.width * 0.06))
                            .bold(true)
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)))
                    }
                    else{
                        Text("No Apps Selected.")
                            .font(. system(size: UIScreen.main.bounds.width * 0.06))
                            .bold(true)
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)))
                    }
                    Spacer()
//                    ScrollView{
//                        VStack{
//                            if viewModel.appTokenTempNames.count > 0{
//                                ForEach(0..<viewModel.appTokenTempNames.count, id: \.self) { nameIndex in
//                                    Text("\(viewModel.appTokenTempNames[nameIndex]) Selected")
//                                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
//                                        .background(Color(.blue))
//                                }
//                            }
//                        }
//                    }
//                    .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.4, alignment: .top)
                    if editView {
                        CustomSubmitButton(title: "Update", action: {viewModel.setBlockGroupPressed ? nil : viewModel.editBlockGroupTask(oldBlockGroupName:blockGroupName)})
                    }
                    else{
                        CustomSubmitButton(title: "Save", action: {viewModel.setBlockGroupPressed ? nil : viewModel.saveBlockGroupTask()})
                    }
                    Spacer()
                }// VStack
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
    }
}
