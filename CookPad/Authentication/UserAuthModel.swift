//
//  UserAuthModel.swift
//  CookPad
//
//  Created by Mariano Arselan on 06-02-26.
//

import Foundation
import GoogleSignIn
import Observation
import FirebaseAuth

protocol UserAuthModelProtocol {
    func tryRestoreSession() async
    func signIn() async
    func signOut()
    var token: String? { get async }
    var givenName: String { get }
    var email: String { get }
    var imageUrl : String { get }
}


@Observable
class UserAuthModel: UserAuthModelProtocol {
    enum Status {
        case unknown
        case restoring
        case loggedIn
        case loggedOut
        case error(String)
    }
    @ObservationIgnored
    private var googleUser: GIDGoogleUser?
    @ObservationIgnored
    private var jwtToken: String?
    private let attribute = "jwtToken"
    var status: Status = .unknown
    
    
    var givenName: String { googleUser?.profile?.givenName ?? "Not logged in" }
    var imageUrl : String { googleUser?.profile?.imageURL(withDimension: 100)?.absoluteString ?? "" }
    var email: String { googleUser?.profile?.email ?? "Unknown mail" }
    
    var token: String? {
        get async {
            try? await Auth.auth().currentUser?.getIDToken()
        }
    }
    
    func tryRestoreSession() async {
        status = .restoring
        do {
            self.googleUser = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            self.status = .loggedIn
        } catch {
            await setStatus(.error(error.localizedDescription), nil)
        }
    }
    
    private func setStatus(_ status: Status, _ user: GIDGoogleUser?) async {
        await MainActor.run {
            self.status = status
            self.googleUser = user
        }
    }
    
    func signIn() async {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        do {
            let status = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = status.user
            // get token
            guard let idToken = user.idToken?.tokenString else {
                await setStatus(.error("Cannot retrieve token from Firebase"), nil)
                return
            }
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            _ = try await Auth.auth().signIn(with: credential)
            // set status
            await setStatus(.loggedIn, user)
        } catch {
            await setStatus(.error(error.localizedDescription), nil)
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.googleUser = nil
        self.status = .loggedOut
    }
    
    private func saveToken(_ token: String) {
        let data = Data(token.utf8)
        // Remove token if exists
        SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "jwtToken"
        ] as CFDictionary)
        // Save token
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "jwtToken",
            kSecValueData: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getJwtToken() -> String? {
        if let jwtToken {
            return jwtToken
        }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: attribute,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
           let data = result as? Data,
           let jwtToken = String(data: data, encoding: .utf8) {
            return jwtToken
        }
        return nil
    }
}

class MockUserAuthModel: UserAuthModelProtocol {
    func check(_ onLoggedIn: (() -> Void)? = nil) {}
    func tryRestoreSession() async {}
    func signIn() async {}
    func signOut() {}
    var token: String? { nil }
    var givenName: String { "Mock Name" }
    var email: String { "mock@mail.com" }
    var imageUrl : String { "" }
}

