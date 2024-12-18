//
//  SliderBar.swift
//  BackToLife
//
//  Created by Eric Viera on 11/14/24.
//

import Foundation
import SwiftUI

struct SliderBar: View {
    @State var sliderVal: Double = 0
    var body: some View{
        VStack{
            HStack(spacing: 0){
                Text("Set Time: ")
                Text(String(format:"%.0f", sliderVal))
                Text(" minutes")
            }
            Slider(value: $sliderVal, in: 0...30, step: 30,label: {Text("Title")}, minimumValueLabel: {Text("0")}, maximumValueLabel: {Text("30")})
        }
    }
}
