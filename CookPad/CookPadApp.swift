//
//  CookPadApp.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import SwiftUI
import Swinject
import FirebaseCore

@main
struct CookPadApp: App {
    enum Status {
        case ok
        case error
    }
    init() {
        Resolver.shared.register(StorageProtocol.self) { _ in
            Storage()
        }.inObjectScope(.container)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
