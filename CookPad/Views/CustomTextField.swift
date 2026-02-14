//
//  CustomTextField.swift
//  CookPad
//
//  Created by Mariano Arselan on 02-02-26.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var height: CGFloat = 40
    
    var body: some View {
        TextField(title, text: $text)
            .textFieldStyle(CustomTextFieldStyle(height: height))
    }
}

#Preview {
    @Previewable @State var text = ""
    CustomTextField(title: "Name:", text: $text)
}
