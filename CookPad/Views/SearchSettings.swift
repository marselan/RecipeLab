//
//  SearchSettings.swift
//  CookPad
//
//  Created by Mariano Arselan on 04-02-26.
//

import SwiftUI

struct SearchSettings: View {
    
    @AppStorage("searchFilter") private var selectedOption = "name"
    
    private var options: [String] = ["name", "ingredient"]
    
    var body: some View {
            Picker("Filter by", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(.menu)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}

#Preview {
    SearchSettings()
}
