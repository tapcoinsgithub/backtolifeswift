//
//  PopUpOptionalComponent.swift
//  BackToLife
//
//  Created by Eric Viera on 12/9/24.
//

import Foundation
import SwiftUI

struct PopUpOptionalComponent: View {
    
    let descriptionText:String
    let buttonOneAction: () -> Void
    let buttonOneText:String
    let buttonTwoAction: () -> Void
    let buttonTwoText:String
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Text(descriptionText)
                .foregroundColor(.black)
                .font(. system(size: UIScreen.main.bounds.width * 0.04))
                .bold(true)
            Spacer()
            HStack{
                Button(action: {
                    buttonOneAction()
                }){
                    Text(buttonOneText)
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                                .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)
                                .fill(Color(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)))
                        )
                        .foregroundColor(Color(.black))
                }
                Button(action: {
                    buttonTwoAction()
                }){
                    Text(buttonTwoText)
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                                .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)
                                .fill(Color(#colorLiteral(red: 0.4332143962, green: 0.4685660005, blue: 0.5035330057, alpha: 1)))
                        )
                        .foregroundColor(Color(.black))
                }
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.05)
                .stroke(Color.black, lineWidth: UIScreen.main.bounds.width * 0.01)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0, green: 1, blue: 0.273470372, alpha: 1)), Color(#colorLiteral(red: 0.7487995028, green: 0.3212949336, blue: 1, alpha: 1))]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
        )
    }
}
