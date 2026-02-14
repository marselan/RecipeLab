//
//  SearchViewModel.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import Foundation
import Observation
import Combine
import Swinject

@Observable
class SearchViewModel {
    enum Status {
        case idle
        case loading
        case error
        case notFound
        case found([Meal])
        case foundByIngredient([Meal])
    }
    
    var status: Status = .idle
    @ObservationIgnored
    @Inject var storage: StorageProtocol
    
    
    func clear() {
        status = .idle
    }
    
    func fetchMeals(filterBy: String, string: String) {
        Task { @MainActor in
            do {
                status = .loading
                let meals: [Meal]
                if filterBy == "name" {
                    meals = try await storage.getMeals(name: string)
                } else {
                    meals = try await storage.getMeals(ingredient: string)
                }
                if meals.isEmpty {
                    status = .notFound
                } else {
                    if filterBy == "name" {
                        status = .found(meals)
                    } else {
                        status = .foundByIngredient(meals)
                    }
                }
            } catch {
                status = .error
            }
        }
    }
}
