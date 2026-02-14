//
//  EnvironmentVars.swift
//  CookPad
//
//  Created by Mariano Arselan on 09-02-26.
//

import Foundation

enum EnvironmentVarsKeys: String {
    case baseUrl = "RECIPES_BASE_URL"
    case apiKey = "RECIPES_API_KEY"
}

class EnvironmentVars {
    static func get(_ key: EnvironmentVarsKeys) -> String? {
        Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
    }
}
