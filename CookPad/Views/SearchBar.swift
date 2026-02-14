//
//  SearchBar.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @FocusState var isFocused: Bool
    var onSubmit: () -> Void = { }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 42)
                .foregroundColor(Color(.systemGray6))
                .overlay(
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                TextField("Type ingredients...", text: $text)
                    .focused($isFocused)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.clear)
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 10)
                        .foregroundColor(.black)
                }
            }
            )
        }
        .onSubmit {
            onSubmit()
        }
        .cornerRadius(16)
    }
}

#Preview {
    @Previewable @State var text: String = ""
    SearchBar(text: $text)
}
