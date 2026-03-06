//
//  MealPlanDetailViewModel.swift
//  CookPad
//
//  Created by Mariano Arselan on 06-03-26.
//

import Foundation
import Observation

enum PlannedMealState {
    case loading
    case loaded([PlannedMeal])
    case empty
    case error
}

protocol MealPlanDetailViewModelProtocol {
    var state: PlannedMealState { get }
    func fetchMeals(email: String, mealId: String)
}

@Observable
class MealPlanDetailViewModel: MealPlanDetailViewModelProtocol {
    
    @ObservationIgnored
    @Inject var storage: StorageProtocol
    
    var state: PlannedMealState = .loading
    
    func fetchMeals(email: String, mealId: String) {
        Task { @MainActor in
            do {
                state = .loading
                let meals = try await storage.fetchScheduledMeals(email: email, byMealId: mealId)
                if meals.count == 0 {
                    state = .empty
                } else {
                    state = .loaded(meals)
                }
            } catch {
                state = .error
            }
        }
    }
}
