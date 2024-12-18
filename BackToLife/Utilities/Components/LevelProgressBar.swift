//
//  LevelProgressBar.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftUI

struct LevelProgressBar: View {
    let levelProgressWidth:Double
    var body: some View{
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.02, style: .continuous)
                .stroke(Color.white, lineWidth: UIScreen.main.bounds.width * 0.002)
                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.02)
                .foregroundColor(Color.black.opacity(0.05))
            RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.02, style: .continuous)
                .frame(width: UIScreen.main.bounds.width * levelProgressWidth, height: UIScreen.main.bounds.height * 0.02)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.661377728, green: 0.1648784578, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.1411406398, green: 0.1199080124, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.680336237, blue: 0.9861831069, alpha: 1))]), startPoint: .leading, endPoint: .trailing).clipShape(RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.05, style: .continuous)))
                .foregroundColor(.clear)
        }
    }
}
