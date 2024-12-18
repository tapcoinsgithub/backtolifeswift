//
//  ForgotUsernameViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 12/2/24.
//

import Foundation
import SwiftUI

final class ForgotUsernameViewModel: ObservableObject {
    @Published var phone_number:String = ""
    @Published var send_pressed:Bool = false
    @Published var is_phone_error = false
    @Published var phoneError = "Invalid Phone Number."
    @Published var successfully_sent = false
    private var globalVariables = GlobalVariables()
    
    func sendUsernameTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.send_pressed = true
                    self.is_phone_error = false
                    self.successfully_sent = false
                }
                if phone_number == ""{
                    DispatchQueue.main.async {
                        self.is_phone_error = true
                        self.send_pressed = false
                        self.successfully_sent = false
                        self.phoneError = "Phone Number is Required."
                    }
                    return
                }
                
                if self.validate_phone_number(value: phone_number) == false{
                    DispatchQueue.main.async {
                        self.is_phone_error = true
                        self.send_pressed = false
                        self.successfully_sent = false
                    }
                    return
                }
                let result:Bool = try await sendUsername()
                if result{
                    print("Success")
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.is_phone_error = true
                        self.phoneError = "Something went wrong."
                    }
                }
                DispatchQueue.main.async {
                    self.send_pressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.send_pressed = false
                    self.is_phone_error = true
                    self.phoneError = "Something went wrong."
                }
            }
        }
    }
    
    func sendUsername() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/send_username"
        
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
            let response = try JSONDecoder().decode(Response.self, from: data)
            if response.response{
                DispatchQueue.main.async {
                    self.successfully_sent = true
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
    
    struct Response:Codable {
        let response: Bool
        let message: String
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
