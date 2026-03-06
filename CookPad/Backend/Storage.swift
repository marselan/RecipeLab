//
//  Storage.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import Foundation
import Observation
import FirebaseFirestore

enum StorageError: Error {
    case noDataAvailable
    case unableToDecode
    case invalidUrl
    case unknown
    case invalidResponse
    case invalidConfiguration
    case invalidId
}

protocol StorageProtocol {
    func getRandomMeals() async throws -> [Meal]
    func getMeals(name: String) async throws -> [Meal]
    func getMeals(ingredient: String) async throws -> [Meal]
    func getMeal(id: String) async throws -> Meal?
    
    func fetchFavorites(email: String) async throws -> [FavoriteRecipe]
    func addFavorite(email: String, favoriteRecipe: FavoriteRecipe) async throws
    func removeFavorite(email: String, id: String) async throws
    
    func fetchNote(email: String, id: String) async throws -> Note?
    func saveNote(email: String, note: Note) async throws
    
    func scheduleMeal(email: String, plannedMeal: PlannedMeal) async throws -> String
    func updateScheduledMeal(email: String, plannedMeal: PlannedMeal) async throws
    func fetchScheduledMeals(email: String, byMealId: String) async throws -> [PlannedMeal]
}

class Storage: StorageProtocol {
    
    let baseUrl: String
    let apiKey: String
    
    init() {
        baseUrl = EnvironmentVars.get(.baseUrl) ?? ""
        apiKey = EnvironmentVars.get(.apiKey) ?? ""
    }
    
    let mealStr = "%@/api/json/v2/%@/search.php?s=%@"
    
    func getMeals(name: String) async throws -> [Meal] {
        let urlStr = String(format: mealStr, baseUrl, apiKey, name).replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlStr) else { throw StorageError.invalidUrl }
        let request = URLRequest(url: url)
        guard let (data, response) = try? await URLSession.shared.data(for: request) else { throw StorageError.noDataAvailable }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw StorageError.invalidResponse }
        guard let meals = try? JSONDecoder().decode(Meals.self, from: data) else { throw StorageError.unableToDecode }
        guard let meals = meals.meals else { return [] }
        return meals
    }
    
    let ingredientStr = "%@/api/json/v2/%@/filter.php?i=%@"
    
    func getMeals(ingredient: String) async throws -> [Meal] {
        let urlStr = String(format: ingredientStr, baseUrl, apiKey, ingredient).replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlStr) else { throw StorageError.invalidUrl }
        let request = URLRequest(url: url)
        guard let (data, response) = try? await URLSession.shared.data(for: request) else { throw StorageError.noDataAvailable }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw StorageError.invalidResponse }
        guard let meals = try? JSONDecoder().decode(Meals.self, from: data) else { throw StorageError.unableToDecode }
        guard let meals = meals.meals else { return [] }
        return meals
    }
    
    let mealById = "%@/api/json/v2/%@/lookup.php?i=%@"
    
    func getMeal(id: String) async throws -> Meal? {
        let urlStr = String(format: mealById, baseUrl, apiKey, id)
        guard let url = URL(string: urlStr) else { throw StorageError.invalidUrl }
        let request = URLRequest(url: url)
        guard let (data, response) = try? await URLSession.shared.data(for: request) else { throw StorageError.noDataAvailable }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw StorageError.invalidResponse }
        guard let meals = try? JSONDecoder().decode(Meals.self, from: data) else { throw StorageError.unableToDecode }
        guard let meals = meals.meals, meals.count == 1 else { return nil }
        return meals[0]
    }
    
    let randomMeals = "%@/api/json/v2/%@/randomselection.php"
    
    func getRandomMeals() async throws -> [Meal] {
        let urlStr = String(format: randomMeals, baseUrl, apiKey)
        guard let url = URL(string: urlStr) else { throw StorageError.invalidUrl }
        let request = URLRequest(url: url)
        guard let (data, response) = try? await URLSession.shared.data(for: request) else { throw StorageError.noDataAvailable }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw StorageError.invalidResponse }
        let meals = try JSONDecoder().decode(Meals.self, from: data)
        guard let meals = meals.meals else { return [] }
        return meals
    }
    
    func fetchFavorites(email: String) async throws -> [FavoriteRecipe] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("users").document(email).collection("favorites").getDocuments()
        
        let favorites = snapshot.documents.compactMap { document in
            try? document.data(as: FavoriteRecipe.self)
        }
        return favorites
    }
    
    func addFavorite(email: String, favoriteRecipe: FavoriteRecipe) async throws {
        let db = Firestore.firestore()
        guard let id = favoriteRecipe.id else { throw StorageError.invalidId }
        try db.collection("users").document(email).collection("favorites").document(id).setData(from: favoriteRecipe)
    }
    
    func removeFavorite(email: String, id: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("users").document(email).collection("favorites").document(id).delete()
    }
    
    func fetchNote(email: String, id: String) async throws -> Note? {
        let db = Firestore.firestore()
        let document = try await db.collection("users").document(email).collection("notes").document(id).getDocument()
        return try? document.data(as: Note.self)
    }
    
    func saveNote(email: String, note: Note) async throws {
        let db = Firestore.firestore()
        guard let id = note.id else { throw StorageError.invalidId }
        try db.collection("users").document(email).collection("notes").document(id).setData(from: note)
    }
    
    func scheduleMeal(email: String, plannedMeal: PlannedMeal) async throws -> String {
        let db = Firestore.firestore()
        let scheduledMeal = toScheduledMeal(plannedMeal)
        let documentRef = try db.collection("users").document(email).collection("scheduledMeals").addDocument(from: scheduledMeal)
        return documentRef.documentID
    }
    
    func updateScheduledMeal(email: String, plannedMeal: PlannedMeal) async throws {
        let db = Firestore.firestore()
        let scheduledMeal = toScheduledMeal(plannedMeal)
        try db.collection("users").document(email).collection("scheduledMeals").document(plannedMeal.id).setData(from: scheduledMeal)
    }
    
    func fetchScheduledMeals(email: String, byMealId: String) async throws -> [PlannedMeal] {
        let db = Firestore.firestore()
        let query = db.collection("users")
            .document(email)
            .collection("scheduledMeals")
            .whereField("mealId", isEqualTo: byMealId)
        let snapshot = try await query.getDocuments()
        let scheduledMeals = snapshot.documents.compactMap { doc in
            try? doc.data(as: ScheduledMeal.self)
        }
        return scheduledMeals.map { meal in
            fromScheduledMeal(meal)
        }
        .filter({ $0.date > Calendar.current.startOfDay(for: Date()) })
        .sorted(by: { $0.date < $1.date })
    }
}

