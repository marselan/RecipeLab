//
//  Capitalized.swift
//  CookPad
//
//  Created by Mariano Arselan on 30-01-26.
//

import Foundation

@propertyWrapper
struct Capitalized {
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.capitalized
        }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}
