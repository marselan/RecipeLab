//
//  MealDetailViewModel.swift
//  CookPad
//
//  Created by Mariano Arselan on 06-02-26.
//

import Foundation
import Observation
import Swinject

@Observable
class MealDetailViewModel {
    @ObservationIgnored
    @Inject var storage: StorageProtocol
    
    enum Status {
        case loading
        case loaded(Meal)
        case failed
    }
    
    var status: Status = .loading
    
    func fetchMeal(id: String) {
        Task { @MainActor in
            do {
                status = .loading
                guard let meal = try await storage.getMeal(id: id) else {
                    status = .failed
                    return
                }
                status = .loaded( meal )
            } catch {
                status = .failed
            }
        }
    }
}
