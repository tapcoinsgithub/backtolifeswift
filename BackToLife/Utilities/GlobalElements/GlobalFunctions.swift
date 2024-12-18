//
//  GlobalFunctions.swift
//  BackToLife
//
//  Created by Eric Viera on 12/9/24.
//

import Foundation
import SwiftUI

class GlobalFunctions {
    @AppStorage("session") var logged_in_user: String?
    private var globalVariables = GlobalVariables()
        
    func logout() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/logout"
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(LogoutResponse.self, from: data)
            if response.result == "Success"{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
        
    struct LogoutResponse:Codable {
        let result: String
    }
}
