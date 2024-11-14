//
//  Item.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
