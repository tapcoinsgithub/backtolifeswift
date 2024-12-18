//
//  ForgotPasswordViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 12/2/24.
//

import Foundation
import SwiftUI

final class ForgotPasswordViewModel: ObservableObject {
    @Published var phone_number:String = ""
    @Published var code:String = ""
    @Published var password:String = ""
    @Published var c_password:String = ""
    @Published var error:String = ""
    @Published var send_pressed:Bool = false
    @Published var is_phone_error = false
    @Published var is_error = false
    @Published var is_match_error = false
    @Published var is_password_error = false
    @Published var successfully_sent = false
    @Published var submitted = false
    private var globalVariables = GlobalVariables()
    
    func sendCodeTask(){
        Task {
            do {
                DispatchQueue.main.async{
                    self.send_pressed = true
                    self.is_phone_error = false
                    self.successfully_sent = false
                    self.submitted = false
                }
                if phone_number == ""{
                    DispatchQueue.main.async{
                        self.is_phone_error = true
                        self.send_pressed = false
                        self.successfully_sent = false
                        self.submitted = false
                    }
                    return
                }
                
                if self.validate_phone_number(value: phone_number) == false {
                    DispatchQueue.main.async{
                        self.is_phone_error = true
                        self.send_pressed = false
                        self.successfully_sent = false
                    }
                    return
                }
                let result:Bool = try await send_code()
                if !result{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.send_pressed = false
                        self.is_error = true
                        self.error = "Could not send code."
                    }
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async{
                    self.send_pressed = false
                    self.is_error = true
                    self.error = "Something went wrong."
                }
            }
        }
    }
    
    func send_code() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/send_code"
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "phone_number=" + phone_number
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response.self, from: data)
            if response.response{
                DispatchQueue.main.async {
                    self.successfully_sent = true
                    self.send_pressed = false
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
    
    func submitTask(){
        Task {
            do {
                DispatchQueue.main.async{
                    self.send_pressed = true
                    self.is_error = false
                    self.is_match_error = false
                    self.is_password_error = false
                    self.submitted = false
                }
                
                if password != c_password{
                    DispatchQueue.main.async{
                        self.is_match_error = true
                        self.is_password_error = false
                        self.send_pressed = false
                    }
                    return
                }
                
                if password == "" {
                    DispatchQueue.main.async{
                        self.is_password_error = true
                        self.is_match_error = false
                        self.send_pressed = false
                    }
                    return
                }
                let result:Bool = try await submit()
                if !result{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async{
                    self.send_pressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async{
                    self.send_pressed = false
                    self.is_error = true
                    self.error = "Something went wrong."
                }
            }
        }
    }
    
    func submit() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/change_password"
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "code=" + code + "&password=" + password
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response2.self, from: data)
            if response.response{
                if response.expired{
                    DispatchQueue.main.async{
                        self.is_error = true
                        self.error = "Expired code."
                    }
                    return false
                }
                else{
                    DispatchQueue.main.async{
                        self.submitted = true
                    }
                }
            }
            else{
                let errorType = Error_Types.allCases.first(where: { $0.index == response.error_type })
                if errorType == Error_Types.BlankPassword{
                    DispatchQueue.main.async{
                        self.is_error = true
                        self.error = response.message
                    }
                    return false
                }
                if errorType == Error_Types.PreviousPassword{
                    DispatchQueue.main.async{
                        self.is_error = true
                        self.error = response.message
                    }
                    return false
                }
                if errorType == Error_Types.SomethingWentWrong{
                    DispatchQueue.main.async{
                        self.is_error = true
                        self.error = response.message
                    }
                    return false
                }
                if errorType == Error_Types.TimeLimitCode{
                    DispatchQueue.main.async{
                        self.is_error = true
                        self.error = response.message
                    }
                    return false
                }
            }
        }
        catch{
            throw PostDataError.invalidData
        }
        return true
    }
    
    struct Response:Codable {
        let response: Bool
    }
    
    struct Response2:Codable {
        let response: Bool
        let message: String
        let expired: Bool
        let error_type: Int
    }
    
    func validate_phone_number(value: String) -> Bool {
        let int_phone_number = Int(value) ?? 0
        if int_phone_number == 0 {
            return false
        }
        if int_phone_number > 9999999999999999 || int_phone_number <= 0{
            return false
        }
        else{
            let phone_regex = #"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}"#
            return NSPredicate(format: "SELF MATCHES %@", phone_regex).evaluate(with: value)
        }
    }
}
