//
//  ScheduleMealViewModel.swift
//  CookPad
//
//  Created by Mariano Arselan on 27-02-26.
//

import Foundation
import Observation
import FirebaseCore

@Observable
class ScheduleMealViewModel {
    
    @ObservationIgnored
    @Inject var storage: StorageProtocol
    
    enum State {
        case initial(String?)
        case saving
        case saved(String)
        case errorSaving
        case errorUpdating(String)
    }
    
    var state: State = .initial(nil)
    
    func schedule(email: String, mealId: String, type: Int, date: Date) {
        Task { @MainActor in
            do {
                state = .saving
                let scheduledMeal = PlannedMeal(mealId: mealId, type: type, date: date)
                let docId = try await storage.scheduleMeal(email: email, plannedMeal: scheduledMeal)
                state = .saved(docId)
            } catch {
                state = .errorSaving
            }
        }
    }
    
    func update(email: String, docId: String, mealId: String, type: Int, date: Date) {
        Task { @MainActor in
            do {
                state = .saving
                let scheduledMeal = PlannedMeal(mealId: mealId, type: type, date: date)
                try await storage.updateScheduledMeal(email: email, id: docId, plannedMeal: scheduledMeal)
                state = .saved(docId)
            } catch {
                state = .errorUpdating(docId)
            }
        }
    }
    
    func edit(docId: String) {
        state = .initial(docId)
    }
}
