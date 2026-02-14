//
//  UserDefaultsBacked.swift
//  CookPad
//
//  Created by Mariano Arselan on 30-01-26.
//

import Foundation

@propertyWrapper
struct UserDefaultsBacked<Value> {
    var key: String
    var storage: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get { storage.value(forKey: key) as? Value }
        set { storage.set(newValue, forKey: key) }
    }
}
