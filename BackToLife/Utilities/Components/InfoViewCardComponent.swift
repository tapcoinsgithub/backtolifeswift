//
//  InfoViewCardComponent.swift
//  BackToLife
//
//  Created by Eric Viera on 12/5/24.
//

import Foundation
import SwiftUI

struct InfoViewCardComponent: View {
    
    let heading:String
    let pages:String
    let description:String
    
    var body: some View {
        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.14){
            HStack{
                Text(heading)
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .foregroundColor(Color(.white))
                    .fontWeight(.bold)
                    .underline(true)
                Spacer()
                Text(pages)
                    .font(.system(size: UIScreen.main.bounds.width * 0.03))
                    .foregroundColor(Color(.white))
                    .fontWeight(.bold)
            }
            .padding()
            Text(description)
                .font(.system(size: UIScreen.main.bounds.width * 0.055))
                .foregroundColor(Color(.white))
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
        .background(Color(.clear))
        .cornerRadius(UIScreen.main.bounds.width * 0.03)
        VStack{
            Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 1, blue: 0.273470372, alpha: 1)))
                .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.005)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
    }
}
