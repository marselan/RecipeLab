//
//  PlannedMeal.swift
//  CookPad
//
//  Created by Mariano Arselan on 06-03-26.
//

import Foundation

struct PlannedMeal: Identifiable {
    var id: String = UUID().uuidString
    let mealId: String
    let type: Int
    let date: Date
}
