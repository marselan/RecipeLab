//
//  UserAuthEnvironment.swift
//  CookPad
//
//  Created by Mariano Arselan on 09-02-26.
//

import Foundation
import SwiftUI

struct AuthServiceKey: EnvironmentKey {
    static let defaultValue: UserAuthModelProtocol = MockUserAuthModel()
}

extension EnvironmentValues {
    var authService: UserAuthModelProtocol {
        get {
            self[AuthServiceKey.self]
        } set {
            self[AuthServiceKey.self] = newValue
        }
    }
}
