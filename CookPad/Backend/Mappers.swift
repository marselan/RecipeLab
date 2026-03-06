//
//  Mappers.swift
//  CookPad
//
//  Created by Mariano Arselan on 06-03-26.
//

import Foundation
import FirebaseFirestore

func fromScheduledMeal(_ scheduledMeal: ScheduledMeal) -> PlannedMeal {
    PlannedMeal(
        id: scheduledMeal.id ?? UUID().uuidString,
        mealId: scheduledMeal.mealId,
        type: scheduledMeal.type,
        date: scheduledMeal.date.dateValue()
    )
}

func toScheduledMeal(_ plannedMeal: PlannedMeal) -> ScheduledMeal {
    ScheduledMeal(mealId: plannedMeal.mealId, type: plannedMeal.type, date: Timestamp(date: plannedMeal.date))
}
