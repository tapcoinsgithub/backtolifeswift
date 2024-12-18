//
//  BackButtonView.swift
//  BackToLife
//
//  Created by Eric Viera on 11/25/24.
//

import Foundation
import SwiftUI

struct BackButtonView: View {
//    @AppStorage("haptics") var haptics_on:Bool?
//    @AppStorage("darkMode") var darkMode: Bool?
    @Environment(\.presentationMode) var presentationMode
    var opposite:Bool = false
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.left.circle.fill") // You can use any image or view here
                .foregroundColor(Color(.white)
                ) // Change the color of the back button
                    .font(.title)
        })
    }
}
