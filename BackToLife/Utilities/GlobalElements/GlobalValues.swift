//
//  GlobalValues.swift
//  BackToLife
//
//  Created by Eric Viera on 11/17/24.
//

import Foundation
import SwiftUI

struct GlobalVariables {
    var apiUrl:String = "http://127.0.0.1:8000"
//    init(){
//        let envDict = Bundle.main.infoDictionary?["LSEnvironment"] as! Dictionary<String, Any>
//        let envStr = envDict["ENV_SETTING"]! as? String ?? "0"
//        
//        let apiUrlNSArray = envDict["API_URL"]! as? NSArray
//        let apiUrlArray = apiUrlNSArray as? Array<String>
//        self.apiUrl = (apiUrlArray?[Int(envStr) ?? 0])!
//        
//        let gameSocketNSArray = envDict["GAME_SOCKET"]! as? NSArray
//        let gameSocketArray = gameSocketNSArray as? Array<String>
//        self.gameSocket = (gameSocketArray?[Int(envStr) ?? 0])!
//        
//        let customGameSocketNSArray = envDict["CUSTOM_GAME_SOCKET"]! as? NSArray
//        let customGameSocketArray = customGameSocketNSArray as? Array<String>
//        self.customGameSocket = (customGameSocketArray?[Int(envStr) ?? 0])!
//        
//        let queueSocketNSArray = envDict["QUEUE_SOCKET"]! as? NSArray
//        let queueSocketArray = queueSocketNSArray as? Array<String>
//        self.queueSocket = (queueSocketArray?[Int(envStr) ?? 0])!
//    }
}
