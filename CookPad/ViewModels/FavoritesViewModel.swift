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
    
    var status: Status = .empty
   
    func fetchFavorites(email: String) {
        Task { @MainActor in
            do {
                guard status == .empty || status == .error else { return }
                status = .loading
                let favorites = try await dbIdentity.fetchFavorites(email: email).map { fromFavoriteRecipe($0) }
                status = .loaded(favorites)
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
    
}
