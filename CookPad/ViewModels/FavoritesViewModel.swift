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
    
    enum Status {
        case loading
        case loaded([Meal])
        case error
    }
    
    @ObservationIgnored
    @Inject var dbIdentity: DBIdentityProtocol
    
    var status: Status = .loading
   
    func fetchFavorites(email: String) {
        Task { @MainActor in
            do {
                status = .loading
                let favorites = try await dbIdentity.fetchFavorites(email: email).map { fromFavoriteRecipe($0) }
                status = .loaded(favorites)
            } catch {
                status = .error
            }
        }
    }
    
}
