//
//  HomeViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings

final class HomeViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user_name") var user_name: String?
    @AppStorage("user_level") var user_level: Double?
    @AppStorage("user_level_progress") var user_level_progress: Int?
    @AppStorage("user_phone_number") var user_phone_number: String?
    @AppStorage("selectedBlockGroup") var selectedBlockGroup: String?
    @AppStorage("selectedBlockGroupName") var selectedBlockGroupName: String?
    @AppStorage("failed_authorization") var failedAuthorization:Int?
    @Published var sliderVal: Double = 0
    @Published var pressedBlockButton: Bool = false
    @Published var currentlyBlocking:Bool = false
    @Published var timerCount:Int = 0
    @Published var startedTimer:Bool = false
    @Published var displayTime:String = ""
    @Published var levelProgressWidth:Double = 0.0
    @Published var blockEnded:Bool = false
    @Published var max_time:Double = 30
    @Published var userLevel:Double = 1.0
    @Published var userLevelProgress:Int = 0
    @Published var noTimeSet:Bool = false
    @Published var sendingTimerProgressVal: Double = 0.0
    @Published var showEndBlockOptional:Bool = false
    @Published var endBlockOptionalText: String = ""
    @Published var noBlockGroupSet:Bool = false
    @Published var loadedUserInfo:Bool = false
    @Published var showStandardError:Bool = false
    @Published var standardErrorMessage:String = "Something went wrong. :("
    let store = ManagedSettingsStore()
    private var globalVariables = GlobalVariables()
    private var globalFunctions = GlobalFunctions()
    private var initialTimerCount = 0
    private var takeTenPercent:Bool = false
    private var inGetCurrentBlockTimeTask:Bool = false
    init() {
        if logged_in_user != nil{
            self.requestAuthorizationTask()
            self.getCurrentBlockTimeTask()
        }
    }
    
    func getCurrentBlockTimeTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.inGetCurrentBlockTimeTask = true
                }
                let result:Bool = try await getCurrentBlockTime()
                if result{
                    print("SUCCESS")
                }
                else{
                    DispatchQueue.main.async {
                        self.showStandardError = true
                    }
                }
                DispatchQueue.main.async {
                    self.inGetCurrentBlockTimeTask = false
                }
            } catch {
                let catch_error = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.showStandardError = true
                    self.inGetCurrentBlockTimeTask = false
                }
                print(catch_error)
//                unblockApps()
            }
        }
    }
    
    func getCurrentBlockTime() async throws -> Bool{
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/get_current_block_time"
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard var urlComponents = URLComponents(string: url_string) else {
            throw PostDataError.invalidURL
        }
        
        // Add query parameters to the URL
        urlComponents.queryItems = [
            URLQueryItem(name: "token", value: session)
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
            let decoder = JSONDecoder()
            let response = try decoder.decode(GetCurrentBlockTimeResponse.self, from: data)
            if response.result == true{
                if response.isBlocking == true {
                    if response.blockEnded{
                        self.blockEndedTask()
                    }
                    else{
                        DispatchQueue.main.async {
                            self.timerCount = response.currentTime
                            self.initialTimerCount = response.initialTime
                            self.currentlyBlocking = true
                            self.startedTimer = true
                        }
                    }
                }
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct GetCurrentBlockTimeResponse:Codable {
        let result: Bool
        let isBlocking: Bool
        let blockEnded: Bool
        let currentTime: Int
        let initialTime: Int
    }

    // API POST Call
    func startBlockTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressedBlockButton = true
                }
                if sliderVal <= 0 {
                    DispatchQueue.main.async {
                        self.pressedBlockButton = false
                        self.noTimeSet = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.noTimeSet = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.noTimeSet = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.noTimeSet = false
                                }
                            }
                        }
                        
                    }
                    return
                }
                if self.selectedBlockGroup == nil {
                    DispatchQueue.main.async {
                        self.pressedBlockButton = false
                        self.noBlockGroupSet = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.noBlockGroupSet = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.noBlockGroupSet = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.noBlockGroupSet = false
                                }
                            }
                        }
                    }
                    return
                }
                let result:Bool = try await startBlock()
                if result{
                    blockApps()
                }
                else{
                    DispatchQueue.main.async {
                        self.showStandardError = true
                    }
                }
                DispatchQueue.main.async {
                    self.pressedBlockButton = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.showStandardError = true
                    self.pressedBlockButton = false
                }
            }
        }
    }
        
    func startBlock() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/start_block"
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        let totalTimeInMinutes = sliderVal * 60
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "token=" + session + "&time_length=" + String(totalTimeInMinutes)
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(StartBlockResponse.self, from: data)
            if response.result == true{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
        
    struct StartBlockResponse:Codable {
        let result: Bool
    }
    
    // API POST Call
    func stopBlockTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressedBlockButton = true
                    self.showEndBlockOptional = false
                }
                let result:Bool = try await stopBlock()
                if result{
                    print("SUCCESS")
                }
                else{
                    DispatchQueue.main.async {
                        self.showStandardError = true
                    }
                }
                DispatchQueue.main.async {
                    self.pressedBlockButton = false
                }
                unblockApps()
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.showStandardError = true
                    self.pressedBlockButton = false
                }
                unblockApps()
            }
        }
    }
        
    func stopBlock() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/stop_block"
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "token=" + session + "&take_ten_percent=" + (takeTenPercent ? "0" : "1")
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(StopBlockResponse.self, from: data)
            if response.result == true{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
        
    struct StopBlockResponse:Codable {
        let result: Bool
    }
    
    // API POST Call
    func blockEndedTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressedBlockButton = true
                }
                let result:Bool = try await blockEnded()
                if result{
                    DispatchQueue.main.async{
                        self.blockEnded = true
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.showStandardError = true
                    }
                }
                unblockApps()
                DispatchQueue.main.async {
                    self.pressedBlockButton = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.showStandardError = true
                    self.pressedBlockButton = false
                }
                unblockApps()
            }
        }
    }
        
    func blockEnded() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
        url_string = tempServerUrl + "/backtolife/block_ended"
        
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
            let response = try decoder.decode(BlockEndedResponse.self, from: data)
            if response.result == true{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
        
    struct BlockEndedResponse:Codable {
        let result: Bool
        let user_level: Int
        let user_level_progress: Int
    }
    
    // API GET Call
    func getUserInfoTask(){
       Task {
           do {
               DispatchQueue.main.async {
                   self.loadedUserInfo = false
               }
               let result:Bool = try await getUserInfo()
               if result{
                   print("SUCCESS")
               }
               else{
                   DispatchQueue.main.async {
                       self.showStandardError = true
                       self.standardErrorMessage = "Unable to get user info. :("
                   }
               }
           } catch {
               _ = "Error: \(error.localizedDescription)"
               DispatchQueue.main.async {
                   self.showStandardError = true
                   self.standardErrorMessage = "Unable to get user info. :("
               }
           }
       }
   }
       
    func getUserInfo() async throws -> Bool{
       var url_string:String = ""
       let serverURL = globalVariables.apiUrl
       let tempServerUrl = "https://backtolife-api-957d3c241fc6.herokuapp.com"
       url_string = tempServerUrl + "/backtolife/get_user_info"
       
       guard var urlComponents = URLComponents(string: url_string) else {
           throw PostDataError.invalidURL
       }
       guard let session = logged_in_user else {
           throw UserErrors.invalidSession
       }
       
       urlComponents.queryItems = [
           URLQueryItem(name: "token", value: session)
       ]
       
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
           let response = try JSONDecoder().decode(GetUserInfoResponse.self, from: data)
           if response.result{
               DispatchQueue.main.async {
                   self.user_name = response.username
                   self.user_level = Double(response.user_level)
                   self.user_level_progress = response.user_level_progress
                   if response.user_phone_number != "None"{
                       self.user_phone_number = response.user_phone_number
                   }
                   else{
                       self.user_phone_number = nil
                   }
                   self.levelProgressWidth = self.calculateLevelProgress(uLevelProgress: response.user_level_progress)
                   self.userLevel = Double(response.user_level)
                   self.userLevelProgress = response.user_level_progress
                   self.max_time = 30 * Double(response.user_level)
                   self.loadedUserInfo = true
               }
               
               
           }
           else {
               return false
           }
           return true
       }
       catch{
           print("Error info: \(error)")
           return false
       }
   }
    
    struct GetUserInfoResponse:Codable {
        let result: Bool
        let username:String
        let user_level: Int
        let user_level_progress: Int
        let user_phone_number: String
    }
    
    func handleAuthFailedLogout(){
        Task{
            do{
                let loggedOutUser = try await globalFunctions.logout()
                if loggedOutUser{
                    self.failedAuthorization = 1
                    self.logged_in_user = nil
                }
                else{
                    self.failedAuthorization = 2
                    self.logged_in_user = nil
                }
            }
            catch{
                self.failedAuthorization = 2
                self.logged_in_user = nil
            }
        }
    }
    
    func requestAuthorizationTask(){
        Task {
            let result:Bool = await requestAuthorization()
            if result{
                print("SUCCESS")
            }
            else{
                self.handleAuthFailedLogout()
            }
        }
        @Sendable func requestAuthorization() async -> Bool{
            if #available(iOS 16.0, *) {
                do {
                    try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                    print("Authorization granted")
                    return true
                } catch {
                    print("Authorization failed: \(error.localizedDescription)")
                    return false
                }
            }
            else{
                var isSuccess = false
                AuthorizationCenter.shared.requestAuthorization { result in
                    switch result {
                    case .success:
                        print("Authorization granted")
                        isSuccess = true
                    case .failure(let error):
                        print("Authorization failed: \(error.localizedDescription)")
                    }
                }
                if isSuccess {
                    return true
                }
                else{
                    return false
                }
            }
        }
    }
    
    func blockApps(){
        if selectedBlockGroup != nil {
            var appTokensToBlock: Set<ApplicationToken> = []
            if let data = selectedBlockGroup!.data(using: .utf8) {
                do {
                    let decodedBlockGroup = try JSONDecoder().decode(BlockGroup.self, from: data)
                    let listToDecode = decodedBlockGroup.listOfAppTokens
                    
                    for token in listToDecode{
                        do {
                            if let decodedData = Data(base64Encoded: token) {
                                do {
                                    let decodedToken = try JSONDecoder().decode(Token<Application>.self, from: decodedData)
                                    appTokensToBlock.insert(decodedToken)
                                } catch {
                                    print("Error decoding token:", error)
                                    DispatchQueue.main.async {
                                        self.showStandardError = true
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showStandardError = true
                                }
                            }
                        } catch {
                            print("Error decoding token: \(error)")
                            DispatchQueue.main.async {
                                self.showStandardError = true
                            }
                        }
                    }
                    store.shield.applications = appTokensToBlock
                    currentlyBlocking = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + (sliderVal * 60)) {
                        self.blockEndedTask()
                    }
                } catch {
                    print("Failed to decode BlockGroup: \(error)")
                    DispatchQueue.main.async {
                        self.showStandardError = true
                    }
                }
            }
        }
        else{
            DispatchQueue.main.async {
                self.showStandardError = true
                self.standardErrorMessage = "No Apps to Block. :("
            }
        }
    }
    
    func unblockApps(){
        self.store.shield.applications = nil
        currentlyBlocking = false
        startedTimer = false
        self.getUserInfoTask()
    }
    
    func adjustTime(value:Double) -> String{
        let intValue = Int(value)
        if intValue == 0{
            return "0 min."
        }
        if intValue == 30{
            return "30 min."
        }
        let result = intValue.quotientAndRemainder(dividingBy: 60)
        if result.quotient == 1{
            return "\(result.quotient) hr. \(result.remainder) min."
        }
        else{
            return "\(result.quotient) hrs. \(result.remainder) min."
        }
    }
    
    func adjustTimerCount(){
        if startedTimer == false {
            startedTimer = true
            timerCount = Int(sliderVal) * 60
            initialTimerCount = timerCount
        }
        if timerCount == 0{
            unblockApps()
        }
        let timerProgressBarVal = initialTimerCount - timerCount
        sendingTimerProgressVal = calculateTimerProgress(timerProgress: timerProgressBarVal)
        timerCount -= 1
        let result1 = timerCount.quotientAndRemainder(dividingBy: 60)
        let result2 = result1.quotient.quotientAndRemainder(dividingBy: 60)
        if result2.quotient != 0{
            displayTime = "\(result2.quotient) hr. \(result2.remainder) min. \(result1.remainder) sec."
        }
        else if result2.remainder != 0 {
            displayTime = "\(result2.remainder) min. \(result1.remainder) sec."
        }
        else{
            displayTime = "\(result1.remainder) sec."
        }
    }
    
    func calculateTimerProgress(timerProgress:Int) -> Double{
        let timerProgressDouble: Double = Double(timerProgress) / Double(initialTimerCount)
        let percentOfProgress:Double = 80.0 * timerProgressDouble
        return percentOfProgress / 100.0
    }
    
    func calculateLevelProgress(uLevelProgress:Int) -> Double{
        let userLevelProgressDouble: Double = Double(uLevelProgress) / 100
        let percentOfProgress:Double = 30.0 * userLevelProgressDouble
        return percentOfProgress / 100.0
    }
    
    func showUnblockOptional(){
        let percentOfTimeLeft = Double(timerCount) / Double(initialTimerCount)
        let percentOfTimeTaken = 1 - percentOfTimeLeft
        if percentOfTimeTaken >= 0.1 {
            endBlockOptionalText = "Are you sure you want to end the block? Your level progress will go down 10%."
            takeTenPercent = true
        }
        else{
            endBlockOptionalText = "Are you sure you want to end the block?"
            takeTenPercent = false
        }
        showEndBlockOptional = true
    }
    
    func closeUnblockOptional(){
        showEndBlockOptional = false
    }
}
