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
}
