//
//  DBIdentity.swift
//  CookPad
//
//  Created by Mariano Arselan on 16-02-26.
//

import Foundation
import FirebaseFirestore

protocol DBIdentityProtocol {
    func fetchFavorites(email: String) async throws -> [FavoriteRecipe]
    func addFavorite(email: String, favoriteRecipe: FavoriteRecipe) async throws
    func removeFavorite(email: String, id: String) async throws
}

class DBIdentity: DBIdentityProtocol {
    
    func fetchFavorites(email: String) async throws -> [FavoriteRecipe] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("users").document(email).collection("favorites").getDocuments()
        
        let favorites = snapshot.documents.compactMap { document in
            try? document.data(as: FavoriteRecipe.self)
        }
        return favorites
    }
    
    func addFavorite(email: String, favoriteRecipe: FavoriteRecipe) async throws {
        let db = Firestore.firestore()
        guard let id = favoriteRecipe.id else { return }
        try db.collection("users").document(email).collection("favorites").document(id).setData(from: favoriteRecipe)
    }
    
    func removeFavorite(email: String, id: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("users").document(email).collection("favorites").document(id).delete()
    }
}
