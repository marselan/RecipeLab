//
//  FavoritesViewModel.swift
//  CookPad
//
//  Created by Mariano Arselan on 13-02-26.
//

import Foundation
import Observation 

@Observable
class FavoritesViewModel {
    
    enum Status: Equatable {
        case empty
        case loading
        case loaded([Meal])
        case error
    }
    
    @ObservationIgnored
    @Inject var dbIdentity: DBIdentityProtocol
    private var email = ""
    
    var status: Status = .empty
   
    func fetchFavorites(email: String) {
        Task { @MainActor in
            do {
                guard status == .empty || status == .error else { return }
                status = .loading
                let favorites = try await dbIdentity.fetchFavorites(email: email).map { fromFavoriteRecipe($0) }
                status = .loaded(favorites)
                self.email = email
            } catch {
                status = .error
            }
        }
    }
    
    func isFavorite(meal: Meal) -> Bool {
        switch status {
        case .loaded(let meals):
            return meals.contains(where: { $0.id == meal.id })
        default:
            return false
        }
    }
    
    func toggle(meal: Meal) {
        if isFavorite(meal: meal) {
            removeFavorite(meal: meal)
        } else {
            addFavorite(meal: meal)
        }
    }
    
    private func addFavorite(meal: Meal) {
        Task { @MainActor in
            switch self.status {
            case .loaded(var meals):
                guard let _ = try? await dbIdentity.addFavorite(email: email, favoriteRecipe: toFavoriteRecipe(meal)) else { return }
                
                meals.append(meal)
                status = .loaded(meals)
            default:
                return
            }
        }
    }
    
    private func removeFavorite(meal: Meal) {
        Task { @MainActor in
            switch self.status {
            case .loaded(var meals):
                guard let _ = try? await dbIdentity.removeFavorite(email: email, id: meal.id) else { return }
                guard let index = meals.firstIndex(where: { $0.id == meal.id }) else { return }
                meals.remove(at: index)
                status = .loaded(meals)
            default:
                return
            }
        }
    }
    
}
