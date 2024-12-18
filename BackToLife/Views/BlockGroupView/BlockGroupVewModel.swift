//
//  BlockGroupVewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftUI
import FamilyControls
import ManagedSettings

final class BlockGroupViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("selectedBlockGroup") var selectedBlockGroup: String?
    @AppStorage("selectedBlockGroupName") var selectedBlockGroupName: String?
//    @Published var newAppTokenList: [Data] = []
    @Published var allBlockGroups: [BlockGroup] = []
    private var globalVariables = GlobalVariables()
    @Published var isLoadingBlockGroups:Bool = true
    @Published var deleteBlockGroupPressed:Bool = false
    @Published var showDeleteBlockGroupOptional: Bool = false
    @Published var selectedBlockGroupToDelete:String = ""
    @Published var showStandardError:Bool = false
    @Published var standardErrorMessage:String = "Something went wrong. :("
    
    init(){
        
    }
    
    func getBlockGroupsTask(){
        Task {
            DispatchQueue.main.async {
                self.allBlockGroups = []
            }
            do {
                try await getBlockGroups()
            }
            catch{
                DispatchQueue.main.async {
                    self.showStandardError = true
                }
                print("Error info: \(error)")
            }
        }
    }
    
    func getBlockGroups() async throws{
        var url_string:String = ""
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        let serverURL = globalVariables.apiUrl
        url_string = tempServerUrl + "/backtolife/get_block_groups"
        
        guard var urlComponents = URLComponents(string: url_string) else {
            throw PostDataError.invalidURL
        }
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        // Add query parameters to the URL
        urlComponents.queryItems = [
            URLQueryItem(name: "token", value: session),
        ]
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            throw PostDataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            DispatchQueue.main.async {
                if response.response == "Success"{
                    if response.block_groups.count > 0 {
                        for blockgroup in response.block_groups{
                            let dictionaryString = """
                            \(blockgroup.replacingOccurrences(of: "'", with: "\""))
                            """
                            if let data = dictionaryString.data(using: .utf8) {
                                do {
                                    let newDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                    var newTokenList: [Data] = []
                                    if let tokenList = newDict?["token_list"] as? [Any] {
                                        for token in tokenList {
                                            if let string = token as? String, let data = string.data(using: .utf8) {
                                                newTokenList.append(data)
                                            }
                                            else{
                                                DispatchQueue.main.async {
                                                    self.showStandardError = true
                                                }
                                                return
                                            }
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.showStandardError = true
                                        }
                                        return
                                    }
                                    var newGroupName: String = ""
                                    if let string = newDict!["name"] as? String {
                                        newGroupName = string
                                    }
                                    let newBlockGroup = BlockGroup(listOfAppTokens: newTokenList, blockGroupName: newGroupName)
                                    self.allBlockGroups.append(newBlockGroup)
                                    self.isLoadingBlockGroups = false
                                } catch {
                                    print("Error decoding JSON: \(error)")
                                    DispatchQueue.main.async {
                                        self.showStandardError = true
                                    }
                                    return
                                }
                            } // If let Data
                            else{
                                DispatchQueue.main.async {
                                    self.showStandardError = true
                                }
                                return
                            }
                        } // For Loop Outer
                    }
                    else{
                        self.isLoadingBlockGroups = false
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.showStandardError = true
                    }
                }
            }
        }
        catch{
            print("Error info: \(error)")
            DispatchQueue.main.async {
                self.showStandardError = true
            }
        }
    }
    
    struct Response: Decodable {
        let response: String
        let block_groups: [String]
    }
    
    func selectBlockGroup(blockGroup:BlockGroup){
        do{
            if self.selectedBlockGroupName == blockGroup.blockGroupName{
                self.selectedBlockGroup = nil
                self.selectedBlockGroupName = nil
            }
            else{
                self.selectedBlockGroupName = blockGroup.blockGroupName
                let encodedBlockGroup = try JSONEncoder().encode(blockGroup)
                if let sBlockGroup = String(data: encodedBlockGroup, encoding: .utf8) {
                    self.selectedBlockGroup = sBlockGroup
                }
                else{
                    DispatchQueue.main.async {
                        self.showStandardError = true
                    }
                }
            }
        }
        catch{
            DispatchQueue.main.async {
                self.showStandardError = true
            }
            print("Error decoding token: \(error)")
        }
    }
    
    func deleteBlockGroupTask(){
        Task{
            do {
                if self.deleteBlockGroupPressed{
                    return
                }
                DispatchQueue.main.async {
                    self.deleteBlockGroupPressed = true
                    self.showDeleteBlockGroupOptional = false
                }
                try await deleteBlockGroup()
                DispatchQueue.main.async {
                    self.deleteBlockGroupPressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.showStandardError = true
                    self.deleteBlockGroupPressed = false
                }
                
            }
            
        }
    }
    
    func deleteBlockGroup() async throws{
        var url_string:String = ""
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        let serverURL = "http://127.0.0.1:8000"
        url_string = tempServerUrl + "/backtolife/delete_block_group"
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "token=" + session + "&block_group_name=" + selectedBlockGroupToDelete
        request.httpBody = requestBody.data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for:request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        DispatchQueue.main.async {
            do {
                let response = try JSONDecoder().decode(DeleteBlockGroupResponse.self, from: data)
                if response.response == true{
                    self.allBlockGroups.removeAll(where: { $0.blockGroupName == self.selectedBlockGroupToDelete })
                    self.selectedBlockGroup = nil
                    self.selectedBlockGroupName = nil
                }
                else{
                    self.showStandardError = true
                }
            }
            catch{
                self.showStandardError = true
            }
        }
    }
    
    struct DeleteBlockGroupResponse:Codable {
        let response: Bool
    }
    
    func closeDeleteBlockGroupOptional(){
        self.showDeleteBlockGroupOptional = false
    }
}
