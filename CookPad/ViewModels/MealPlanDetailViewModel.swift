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
                state = .loaded(meals)
            } catch {
                state = .error
            }
        }
    }
}
