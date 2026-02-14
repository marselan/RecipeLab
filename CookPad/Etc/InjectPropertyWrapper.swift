//
//  InjectPropertyWrapper.swift
//  CookPad
//
//  Created by Mariano Arselan on 11-02-26.
//

import Foundation
import Swinject
import SwiftUI

@propertyWrapper
struct Inject<T> {
    
    private var service: T

    init() {
        guard let resolved = Resolver.shared.resolve(T.self) else {
            fatalError("Dependency of type \(T.self) could not be resolved.")
        }
        self.service = resolved
    }

    var wrappedValue: T { service }
}
