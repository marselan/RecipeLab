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
    func check(_ onLoggedIn: (() -> Void)?)
    func signIn(_ onLoggedIn: (() -> Void)?)
    func signOut()
    var givenName: String { get }
    var email: String { get }
    var imageUrl : String { get }
}


@Observable
class UserAuthModel: UserAuthModelProtocol {
    enum Status {
        case unknown
        case checking
        case loggedIn
        case loggedOut
        case error
    }
    private var googleUser: GIDGoogleUser?
    var status: Status = .unknown
    var errorMessage: String?
    
    var givenName: String { googleUser?.profile?.givenName ?? "Not logged in" }
    var imageUrl : String { googleUser?.profile?.imageURL(withDimension: 100)?.absoluteString ?? "" }
    var email: String { googleUser?.profile?.email ?? "Unknown mail" }
    
    func checkStatus(_ onLoggedIn: (() -> Void)? = nil) {
        guard let googleUser = GIDSignIn.sharedInstance.currentUser else {
            googleUser = nil
            status = .loggedOut
            return
        }
        self.googleUser = googleUser
        status = .loggedIn
        onLoggedIn?()
    }
    
    func check(_ onLoggedIn: (() -> Void)? = nil) {
        status = .checking
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let error {
                self?.errorMessage = "error: \(error.localizedDescription)"
                self?.status = .error
            }
            self?.checkStatus(onLoggedIn)
        }
    }
    
    func signIn(_ onLoggedIn: (() -> Void)? = nil) {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] status, error in
            if let error {
                self?.errorMessage = "error: \(error.localizedDescription)"
                self?.status = .error
            }
            
            guard let user = status?.user,
            let idToken = user.idToken?.tokenString
            else {
                self?.errorMessage = "error: no data for user"
                self?.status = .error
                return
            }
            
           
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Task {
                
                do {
                    let authResult = try await Auth.auth().signIn(with: credential)
                    
                    print(authResult.user.uid)
                    // Save this token in KeyChain
                    let token = try await authResult.user.getIDToken()
                    await MainActor.run { [weak self] in
                        self?.googleUser = user
                        self?.status = .loggedIn
                    }
                } catch {
                    print(error)
                }
            }
             
            
          
            
            
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}

class MockUserAuthModel: UserAuthModelProtocol {
    func check(_ onLoggedIn: (() -> Void)? = nil) {}
    func signIn(_ onLoggedIn: (() -> Void)? = nil) {}
    func signOut() {}
    var givenName: String { "Mock Name" }
    var email: String { "mock@mail.com" }
    var imageUrl : String { "" }
}

