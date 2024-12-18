//
//  GlobalEnums.swift
//  BackToLife
//
//  Created by Eric Viera on 11/17/24.
//

import Foundation
import SwiftUI

enum PostDataError:Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

enum UserErrors:Error {
    case invalidSession
}

enum Error_Types: String, CaseIterable  {
    case BlankPassword, PreviousPassword, TimeLimitCode, SomethingWentWrong
    
    var index: Int { Error_Types.allCases.firstIndex(of: self) ?? 0 }
}
