//
//  SearchBar.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import SwiftUI

struct FakeSearchBar: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 42)
                .foregroundColor(Color(.systemGray6))
                .overlay(
            HStack {
                Image(systemName: "magnifyingglass")
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .padding(.leading, 10)
                Text("Type ingredients...")
                    .padding(.vertical, 10)
                    .background(.clear)
                    .foregroundStyle(Color(.systemGray3))
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .padding(.trailing, 10)
                    .foregroundColor(.black)
            }
            )
        }
        .cornerRadius(16)
    }
}

#Preview {
    @Previewable @State var text: String = ""
    SearchBar(text: $text)
}
