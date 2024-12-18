//
//  TimerProgressBar.swift
//  BackToLife
//
//  Created by Eric Viera on 11/25/24.
//

import Foundation
import SwiftUI

struct TimerProgressBar: View {
    let timerProgressWidth:Double
    var body: some View{
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.01, style: .continuous)
                .stroke(Color.white, lineWidth: UIScreen.main.bounds.width * 0.001)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.01)
                .foregroundColor(Color.black.opacity(0.05))
            RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.01, style: .continuous)
                .frame(width: UIScreen.main.bounds.width * timerProgressWidth, height: UIScreen.main.bounds.height * 0.01)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1411406398, green: 0.1199080124, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.680336237, blue: 0.9861831069, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9779711366, blue: 0.3711004853, alpha: 1))]), startPoint: .leading, endPoint: .trailing).clipShape(RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.05, style: .continuous)))
                .foregroundColor(.clear)
        }
    }
}
