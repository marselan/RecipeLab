//
//  Note.swift
//  CookPad
//
//  Created by Mariano Arselan on 23-02-26.
//

import Foundation
import FirebaseFirestore

struct Note: Codable, Identifiable {
    @DocumentID var id: String?
    var text: String
}

struct ScheduledMeal: Codable, Identifiable {
    @DocumentID var id: String?
    let mealId: String
    let type: Int
    let date: Timestamp
}
