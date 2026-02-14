//
//  CustomTextFieldStyle.swift
//  CookPad
//
//  Created by Mariano Arselan on 02-02-26.
//

import Foundation
import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    var height: CGFloat = 20
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: height)
            .font(.system(size: 20, weight: .semibold, design: .rounded))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray5), lineWidth: 1)
            )
        
    }
    
    
}
