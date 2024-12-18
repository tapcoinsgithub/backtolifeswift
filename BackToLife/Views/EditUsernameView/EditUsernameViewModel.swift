//
//  EditUsernameViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 12/2/24.
//

import Foundation
import SwiftUI

final class EditUsernameViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user_name") var user_name: String?
    @Published var password:String = ""
    @Published var username:String = ""
    @Published var isPasswordError:Bool = false
    @Published var passwordError:String = "Invalid Password."
    @Published var isUsernameError:Bool = false
    @Published var usernameError:String = "Invalid Username."
    @Published var buttonPressed:Bool = false
    @Published var showUsernameForm:Bool = false
    @Published var savedUsername:Bool = false
    private var globalVariables = GlobalVariables()
    
    func confirmPasswordTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.buttonPressed = true
                    self.isPasswordError = false
                }
                if password == ""{
                    DispatchQueue.main.async {
                        self.buttonPressed = false
                        self.isPasswordError = true
                        self.passwordError = "Password is required."
                    }
                    return
                }
                let result:Bool = try await confirmPassword()
                if result{
                    print("Success")
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.isPasswordError = true
                    }
                }
                DispatchQueue.main.async {
                    self.buttonPressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.buttonPressed = false
                    self.isPasswordError = true
                    self.passwordError = "Something went wrong."
                }
            }
        }
    }
    
    func confirmPassword() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/confirm_password"
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "token=" + session + "&password=" + password
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(ConfirmPasswordResponse.self, from: data)
            if response.response{
                DispatchQueue.main.async {
                    self.showUsernameForm = true
                }
                return true
            }
            else{
                return false
            }
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct ConfirmPasswordResponse:Codable {
        let response: Bool
    }
    
    func saveUsernameTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.buttonPressed = true
                    self.isUsernameError = false
                }
                if username == ""{
                    DispatchQueue.main.async {
                        self.buttonPressed = false
                        self.isUsernameError = true
                        self.usernameError = "Username is required."
                    }
                    return
                }
                if username.count > 10{
                    DispatchQueue.main.async {
                        self.buttonPressed = false
                        self.isUsernameError = true
                        self.usernameError = "Username must be 10 characters or less."
                    }
                    return
                }
                let result:Bool = try await saveUsername()
                if result{
                    print("Success")
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.isUsernameError = true
                    }
                }
                DispatchQueue.main.async {
                    self.buttonPressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.buttonPressed = false
                    self.isUsernameError = true
                    self.usernameError = "Something went wrong."
                }
            }
        }
    }
    
    func saveUsername() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/save_username"
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "token=" + session + "&username=" + username
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(SaveUsernameResponse.self, from: data)
            if response.response{
                DispatchQueue.main.async {
                    self.savedUsername = true
                    self.user_name = response.message
                }
                return true
            }
            else{
                DispatchQueue.main.async {
                    self.usernameError = response.message
                }
                return false
            }
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct SaveUsernameResponse:Codable {
        let response: Bool
        let message:String
    }
}
