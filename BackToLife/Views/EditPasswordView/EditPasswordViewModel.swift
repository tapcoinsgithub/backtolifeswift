//
//  EditPasswordViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 12/2/24.
//

import Foundation
import SwiftUI

final class EditPasswordViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user_name") var user_name: String?
    @Published var password:String = ""
    @Published var newPassword:String = ""
    @Published var confirmNewPassword:String = ""
    @Published var isPasswordError:Bool = false
    @Published var passwordError:String = "Invalid Password."
    @Published var isNewPasswordError:Bool = false
    @Published var newPasswordError:String = "Invalid Password."
    @Published var buttonPressed:Bool = false
    @Published var showNewPasswordForm:Bool = false
    @Published var savedNewPassword:Bool = false
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
                    self.showNewPasswordForm = true
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
    
    func saveNewPasswordTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.buttonPressed = true
                    self.isNewPasswordError = false
                }
                if newPassword == ""{
                    DispatchQueue.main.async {
                        self.buttonPressed = false
                        self.isNewPasswordError = true
                        self.newPasswordError = "Password is required."
                    }
                    return
                }
                
                if newPassword != confirmNewPassword {
                    DispatchQueue.main.async {
                        self.buttonPressed = false
                        self.isNewPasswordError = true
                        self.newPasswordError = "Passwords must match."
                    }
                    return
                }
                let result:Bool = try await saveNewPassword()
                if result{
                    print("Success")
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.isNewPasswordError = true
                    }
                }
                DispatchQueue.main.async {
                    self.buttonPressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.buttonPressed = false
                    self.isNewPasswordError = true
                    self.newPasswordError = "Something went wrong."
                }
            }
        }
    }
    
    func saveNewPassword() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/change_password"
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "code=Change_Password" + "&token=" + session + "&password=" + newPassword
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(SaveUsernameResponse.self, from: data)
            if response.response{
                DispatchQueue.main.async {
                    self.savedNewPassword = true
                }
                return true
            }
            else{
                DispatchQueue.main.async {
                    let errorType = Error_Types.allCases.first(where: { $0.index == response.error_type })
                    if errorType == Error_Types.BlankPassword{
                        self.newPasswordError = response.message
                    }
                    if errorType == Error_Types.PreviousPassword{
                        self.newPasswordError = response.message
                    }
                    if errorType == Error_Types.SomethingWentWrong{
                        self.newPasswordError = response.message
                    }
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
        let error_type: Int
        let message:String
        let expired:Bool
    }
}
