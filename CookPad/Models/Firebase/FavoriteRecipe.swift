//
//  FavoriteRecipe.swift
//  CookPad
//
//  Created by Mariano Arselan on 16-02-26.
//

import Foundation
import FirebaseFirestore

struct FavoriteRecipe: Codable, Identifiable {
    @DocumentID var id: String?
    var meal: String
    var mealThumb: String
}
