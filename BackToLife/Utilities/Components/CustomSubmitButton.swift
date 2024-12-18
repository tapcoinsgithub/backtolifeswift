//
//  CustomSubmitButton.swift
//  BackToLife
//
//  Created by Eric Viera on 12/9/24.
//

import Foundation
import SwiftUI

struct CustomSubmitButton: View {
//    @AppStorage("haptics") var haptics_on:Bool?
//    @AppStorage("darkMode") var darkMode: Bool?
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(title)
                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                .background(Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)))
                .foregroundColor(Color(.black))
                .cornerRadius(UIScreen.main.bounds.width * 0.02)
                .overlay(
                    RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.02)
                        .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.005)
                )
                .shadow(color:Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)),radius: UIScreen.main.bounds.width * 0.01)
        })
    }
}
