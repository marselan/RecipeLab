//
//  AddNoteView.swift
//  CookPad
//
//  Created by Mariano Arselan on 23-02-26.
//

import SwiftUI

struct AddNoteView: View {
    @State var text = ""
    var body: some View {
        VStack {
            Text("Add a note")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding()
            ScrollView(showsIndicators: false) {
                TextEditor(text: $text)
                    .frame(height: 200)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .overlay (
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    AddNoteView()
}
