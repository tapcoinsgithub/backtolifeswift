//
//  BackgroundModifier.swift
//  BackToLife
//
//  Created by Eric Viera on 12/9/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AnimatedImage(name: "76YS.gif", bundle: .main)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func applyBackground() -> some View {
        self.modifier(BackgroundModifier())
    }
}
