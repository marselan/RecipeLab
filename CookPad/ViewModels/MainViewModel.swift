//
//  MainViewModel.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import Foundation
import Observation
import Swinject

@Observable
class MainViewModel {
    
    enum Status: Equatable {
        case empty
        case loading
        case error
        case loaded([Meal])
    }
    
    @ObservationIgnored
    @Inject var storage: StorageProtocol
    
    var status: Status = .empty
    private var task: Task<Void, Never>?
    private var timer: Timer?
    private var lastRefreshTime: Date?
    
    private final var minRefreshInterval: TimeInterval = 5
    
    func fetchRandomMeals() {
        task = Task { @MainActor in
            do {
                let now = Date()
                if let lastRefreshTime, now.timeIntervalSince(lastRefreshTime) < minRefreshInterval {
                    return
                }
                if status == .empty || status == .error { status = .loading }
                timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] timer in
                    self?.status = .error
                }
                status = .loaded( try await storage.getRandomMeals() )
            } catch {
                status = .error
            }
            lastRefreshTime = Date()
            timer?.invalidate()
        }
    }
}
