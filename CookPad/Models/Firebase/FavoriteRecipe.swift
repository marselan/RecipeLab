//
//  FavoriteRecipe.swift
//  CookPad
//
//  Created by Mariano Arselan on 16-02-26.
//

import Foundation
import FirebaseFirestore

struct FavoriteRecipe: Codable, Identifiable {
    var meal: String
    var mealThumb: String
    @DocumentID var id: String?
}
