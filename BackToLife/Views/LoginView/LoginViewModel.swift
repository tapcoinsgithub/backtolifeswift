//
//  LoginViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user_name") var user_name: String?
    @AppStorage("user_level") var user_level: Double?
    @AppStorage("user_level_progress") var user_level_progress: Double?
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var confirmPassword:String = ""
    @Published var log_pressed:Bool = false
    @Published var isUsernameError:Bool = false
    @Published var isPasswordError:Bool = false
    @Published var isConfirmPasswordError:Bool = false
    @Published var usernameError:String = ""
    @Published var passwordError:String = ""
    @Published var showConfirmPassword:Bool = false
    private var globalVariables = GlobalVariables()
    
    func loginTask(){
            Task {
                do {
                    DispatchQueue.main.async {
                        self.log_pressed = true
                        self.isUsernameError = false
                        self.isPasswordError = false
                        self.isConfirmPasswordError = false
                    }
                    if username == ""{
                        DispatchQueue.main.async {
                            self.log_pressed = false
                            self.isUsernameError = true
                            self.usernameError = "Username Required."
                        }
                        return
                    }
                    if username.count > 10{
                        DispatchQueue.main.async {
                            self.log_pressed = false
                            self.isUsernameError = true
                            self.usernameError = "Username must be 10 characters or less."
                        }
                        return
                    }
                    if password == ""{
                        DispatchQueue.main.async {
                            self.log_pressed = false
                            self.isPasswordError = true
                            self.passwordError = "Password required."
                        }
                        return
                    }
                    if showConfirmPassword{
                        if confirmPassword == ""{
                            DispatchQueue.main.async {
                                self.log_pressed = false
                                self.isPasswordError = true
                                self.isConfirmPasswordError = true
                                self.passwordError = "Confirm Password is Required."
                            }
                            return
                        }
                        if confirmPassword != password{
                            DispatchQueue.main.async {
                                self.log_pressed = false
                                self.isPasswordError = true
                                self.isConfirmPasswordError = true
                                self.passwordError = "Passwords must match."
                            }
                            return
                        }
                    }
                    try await login()
                    DispatchQueue.main.async {
                        self.log_pressed = false
                    }
                } catch {
                    _ = "Error: \(error.localizedDescription)"
                    DispatchQueue.main.async {
                        self.log_pressed = false
                        self.isUsernameError = true
                        self.usernameError = "Something went wrong."
                    }
                    
                }
            }
        }
        
    func login() async throws{
        
        var url_string:String = ""
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        let serverURL = "http://127.0.0.1:8000"
        url_string = tempServerUrl + "/backtolife/user_login"
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "username=" + username + "&password=" + password + "&confirm_password=" + confirmPassword
        request.httpBody = requestBody.data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for:request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        DispatchQueue.main.async {
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                if response.response == "LoggedIn" || response.response == "Registered"{
                    self.user_name = response.username
                    self.logged_in_user = response.token
                    self.user_level = response.level
                    self.user_level_progress = response.level_progress
                }
                else if(response.response == "Registering"){
                    self.showConfirmPassword = true
                }
                else{
                    self.isUsernameError = true
                    self.usernameError = response.response
                }
            }
            catch{
                print("Error: \(error.localizedDescription)")
                self.isUsernameError = true
                self.usernameError = "Something went wrong."
            }
        }
    }
    
    struct Response:Codable {
        let response: String
        let token: String
        let username: String
        let level: Double
        let level_progress: Double
    }
}
