//
//  SettingsViewModel.swift
//  BackToLife
//
//  Created by Eric Viera on 11/24/24.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user_phone_number") var user_phone_number: String?
    @Published var pressed_logout: Bool = false
    private var globalVariables = GlobalVariables()
    private var globalFunctions = GlobalFunctions()
    
    func logoutTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressed_logout = true
                }
                let result:Bool = try await globalFunctions.logout()
                if result{
                    print("SUCCESS")
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.logged_in_user = nil
                    self.pressed_logout = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.logged_in_user = nil
                    self.pressed_logout = false
                }
            }
        }
    }
}
