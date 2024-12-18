//
//  PhoneNumberViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 11/29/24.
//

import Foundation
import SwiftUI

final class PhoneNumberViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user_phone_number") var user_phone_number: String?
    @Published var phoneNumber:String = ""
    @Published var isPhoneNumberError:Bool = false
    @Published var phoneNumberError:String = ""
    @Published var savePhoneNumberPressed:Bool = false
    @Published var showConfirmPhoneNumberForm:Bool = false
    @Published var phoneNumberCode:String = ""
    @Published var isPhoneNumberCodeError:Bool = false
    @Published var phoneNumberCodeError:String = ""
    @Published var confirmCodePressed:Bool = false
    @Published var confirmedCode:Bool = false
    
    init(){
        if user_phone_number != nil{
            phoneNumber = user_phone_number ?? "No Phone Number"
        }
    }
    
    func savePhoneNumberTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.savePhoneNumberPressed = true
                    self.isPhoneNumberError = false
                }
                if phoneNumber == ""{
                    DispatchQueue.main.async {
                        self.savePhoneNumberPressed = false
                        self.isPhoneNumberError = true
                        self.phoneNumberError = "Phone Number is Empty."
                    }
                    return
                }
                if validate_phone_number(value: phoneNumber) == false{
                    DispatchQueue.main.async {
                        self.savePhoneNumberPressed = false
                        self.isPhoneNumberError = true
                        self.phoneNumberError = "Invalid Phone Number given."
                    }
                    return
                }
                try await savePhoneNumber()
                DispatchQueue.main.async {
                    self.savePhoneNumberPressed = true
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.savePhoneNumberPressed = false
                    self.isPhoneNumberError = true
                    self.phoneNumberError = "Something went wrong."
                }
                
            }
        }
    }
        
    func savePhoneNumber() async throws{
        
        var url_string:String = ""
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        let serverURL = "http://127.0.0.1:8000"
        url_string = tempServerUrl + "/backtolife/save_phone_number"
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "token=" + session + "&phone_number=" + phoneNumber
        request.httpBody = requestBody.data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for:request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        DispatchQueue.main.async {
            do {
                let response = try JSONDecoder().decode(SavePhoneNumberResponse.self, from: data)
                if response.result{
                    self.showConfirmPhoneNumberForm = true
                }
                else{
                    self.savePhoneNumberPressed = false
                    self.isPhoneNumberError = true
                    self.phoneNumberError = "Something went wrong"
                }
            }
            catch{
                print("Error: \(error.localizedDescription)")
                self.savePhoneNumberPressed = false
                self.isPhoneNumberError = true
                self.phoneNumberError = "Something went wrong."
            }
        }
    }
    
    struct SavePhoneNumberResponse:Codable {
        let result: Bool
    }
    
    func confirmCodeTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.confirmCodePressed = true
                    self.isPhoneNumberCodeError = false
                }
                if phoneNumber == ""{
                    DispatchQueue.main.async {
                        self.confirmCodePressed = false
                        self.isPhoneNumberCodeError = true
                        self.phoneNumberCodeError = "Code is Empty."
                    }
                    return
                }
                try await confirmCode()
                DispatchQueue.main.async {
                    self.confirmCodePressed = true
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.confirmCodePressed = false
                    self.isPhoneNumberCodeError = true
                    self.phoneNumberCodeError = "Something went wrong."
                }
            }
        }
    }
        
    func confirmCode() async throws{
        
        var url_string:String = ""
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        let serverURL = "http://127.0.0.1:8000"
        url_string = tempServerUrl + "/backtolife/confirm_code"
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "token=" + session + "&code=" + phoneNumberCode + "&phone_number=" + phoneNumber
        request.httpBody = requestBody.data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for:request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        DispatchQueue.main.async {
            do {
                let response = try JSONDecoder().decode(ConfirmCodeResponse.self, from: data)
                if response.result{
                    self.confirmedCode = true
                }
                else{
                    self.confirmCodePressed = false
                    self.isPhoneNumberCodeError = true
                    self.phoneNumberCodeError = response.response
                }
            }
            catch{
                print("Error: \(error.localizedDescription)")
                self.confirmCodePressed = false
                self.isPhoneNumberCodeError = true
                self.phoneNumberCodeError = "Something went wrong."
            }
        }
    }
    
    struct ConfirmCodeResponse:Codable {
        let result: Bool
        let response:String
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
