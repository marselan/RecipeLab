//
//  ScheduledMeal.swift
//  CookPad
//
//  Created by Mariano Arselan on 06-03-26.
//

import Foundation
import FirebaseFirestore

struct ScheduledMeal: Codable, Identifiable  {
    @DocumentID var id: String?
    let mealId: String
    let type: Int
    let date: Timestamp
}
