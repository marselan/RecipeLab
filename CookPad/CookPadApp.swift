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
        let resolver = Resolver.shared
        resolver.register(StorageProtocol.self) { _ in
            Storage()
        }.inObjectScope(.container)
        resolver.register(DBIdentityProtocol.self) { _ in
            DBIdentity()
        }
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
