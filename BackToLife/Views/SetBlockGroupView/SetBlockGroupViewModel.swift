//
//  SetBlockGroupViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 11/17/24.
//

import Foundation
import SwiftUI
import FamilyControls
import ManagedSettings

final class SetBlockGroupViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @Published var blockGroupName:String = ""
    @Published var is_error:Bool = false
    @Published var error:String = "No Name Given."
    @Published var setBlockGroupPressed:Bool = false
    @Published var appTokenTempNames: [String] = []
    @Published var blockGroupSaved: Bool = false
    @Published var editBlockGroupPressed:Bool = false
    @Published var isPickerPresented = false
    @Published var selection = FamilyActivitySelection()
    @Published var showStandardError:Bool = false
    @Published var standardErrorMessage:String = "Something went wrong. :("
    private var appTokenList: [Data] = []
    
    func saveSelection(selection:FamilyActivitySelection){
        appTokenTempNames = []
        appTokenList = []
        let selectedApps = selection.applicationTokens
        let selectedCategoryTokens = selection.categoryTokens
        if selectedApps.count > 0{
            var index = 0
            for appToken in selectedApps{
                do{
                    let encodedToken = try JSONEncoder().encode(appToken)
                    appTokenList.append(encodedToken)
                    appTokenTempNames.append("App(\(index))")
                    index += 1
                }
                catch{
                    DispatchQueue.main.async {
                        self.showStandardError = true
                        self.appTokenList = []
                    }
                    return
                }
            }
        }
        if selectedCategoryTokens.count > 0{
            var index = 0
            for appCategoryToken in selectedCategoryTokens{
                do{
                    let encodedToken = try JSONEncoder().encode(appCategoryToken)
                    appTokenList.append(encodedToken)
                    appTokenTempNames.append("App Category(\(index))")
                    index += 1
                }
                catch{
                    DispatchQueue.main.async {
                        self.showStandardError = true
                        self.appTokenList = []
                    }
                    return
                }
            }
        }
        if selection.webDomainTokens.count > 0{
            DispatchQueue.main.async {
                self.is_error = true
                self.error = "Only saving tokenized applications at this time."
                self.selection = FamilyActivitySelection()
                self.appTokenList = []
                self.appTokenTempNames = []
            }
        }
    }
    
    func saveBlockGroupTask(){
        Task{
            do {
                DispatchQueue.main.async {
                    self.setBlockGroupPressed = true
                    self.is_error = false
                }
                if blockGroupName == ""{
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.error = "Block Name is Required."
                        self.setBlockGroupPressed = false
                    }
                    return
                }
                if blockGroupName.count > 10 {
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.error = "Block Name must be 10 characters or less."
                        self.setBlockGroupPressed = false
                    }
                    return
                }
                if appTokenList == []{
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.error = "No Apps Selected."
                        self.setBlockGroupPressed = false
                    }
                    return
                }
                try await saveBlockGroup()
                DispatchQueue.main.async {
                    self.setBlockGroupPressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.showStandardError = true
                    self.setBlockGroupPressed = false
                }
            }
        }
    }
    
    func saveBlockGroup() async throws{
        var url_string:String = ""
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        let serverURL = "http://127.0.0.1:8000"
        url_string = tempServerUrl + "/backtolife/save_block_group"
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var jsonAppList = ""
        let encodedAppList = try JSONEncoder().encode(appTokenList)
        if let eAppTokenList = String(data: encodedAppList, encoding: .utf8) {
            jsonAppList = eAppTokenList
        }
        else{
            DispatchQueue.main.async {
                self.showStandardError = true
            }
            return
        }
        let requestBody = "token=" + session + "&block_group_name=" + blockGroupName + "&app_tokens=" + jsonAppList
        request.httpBody = requestBody.data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for:request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        DispatchQueue.main.async {
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                if response.response == "Success"{
                    self.blockGroupName = ""
                    self.appTokenTempNames = []
                    self.appTokenList = []
                    self.blockGroupSaved = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.blockGroupSaved = false
                    }
                }
                else{
                    self.is_error = true
                    self.error = response.response
                }
            }
            catch{
                self.showStandardError = true
            }
        }
    }
    
    struct Response:Codable {
        let response: String
    }
    
    func editBlockGroupTask(oldBlockGroupName:String){
        Task{
            do {
                DispatchQueue.main.async {
                    self.editBlockGroupPressed = true
                }
                if appTokenList.count <= 0 {
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.error = "No Apps Selected."
                        self.editBlockGroupPressed = true
                    }
                    return
                }
                if blockGroupName == ""{
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.editBlockGroupPressed = true
                    }
                    return
                }
                try await editBlockGroup(oldBlockGroupName:oldBlockGroupName)
                DispatchQueue.main.async {
                    self.editBlockGroupPressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.showStandardError = true
                    self.editBlockGroupPressed = false
                }
                
            }
            
        }
    }
    
    func editBlockGroup(oldBlockGroupName:String) async throws{
        var url_string:String = ""
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        let serverURL = "http://127.0.0.1:8000"
        url_string = tempServerUrl + "/backtolife/edit_block_group"
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var jsonAppList = ""
        let encodedAppList = try JSONEncoder().encode(appTokenList)
        if let eAppTokenList = String(data: encodedAppList, encoding: .utf8) {
            jsonAppList = eAppTokenList
        }
        else{
            DispatchQueue.main.async {
                self.showStandardError = true
            }
            return
        }
        let requestBody = "token=" + session + "&block_group_name=" + blockGroupName + "&old_block_group_name=" + oldBlockGroupName + "&app_tokens=" + jsonAppList
        request.httpBody = requestBody.data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for:request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        DispatchQueue.main.async {
            do {
                let response = try JSONDecoder().decode(EditBlockGroupResponse.self, from: data)
                if response.response == "Success"{
                    self.blockGroupName = ""
                    self.appTokenTempNames = []
                    self.appTokenList = []
                    self.blockGroupSaved = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.blockGroupSaved = false
                    }
                }
                else{
                    self.is_error = true
                    self.error = response.response
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.showStandardError = true
                }
            }
        }
    }
    
    struct EditBlockGroupResponse:Codable {
        let response: String
    }
}
