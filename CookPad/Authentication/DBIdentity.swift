//
//  DBIdentity.swift
//  CookPad
//
//  Created by Mariano Arselan on 16-02-26.
//

import Foundation
import FirebaseFirestore

protocol DBIdentityProtocol {
    func fetchUserId(email: String) async -> User?
    func fetchFavorites(email: String) async throws -> [FavoriteRecipe]
}

class DBIdentity: DBIdentityProtocol {
    
    func fetchUserId(email: String) async -> User? {
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(email)
        do {
            let user = try await docRef.getDocument(as: User.self) //else { return nil }
            return user
        } catch {
            print(error)
            return nil
            
        }
    }
    
    func fetchFavorites(email: String) async throws -> [FavoriteRecipe] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("users").document(email).collection("favorites").getDocuments()
        
        let favorites = snapshot.documents.compactMap { document in
            try? document.data(as: FavoriteRecipe.self)
        }
        return favorites
    }
}
