//
//  Storage.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import Foundation
import Observation

enum StorageError: Error {
    case noDataAvailable
    case unableToDecode
    case invalidUrl
    case unknown
    case invalidResponse
    case invalidConfiguration
}

protocol StorageProtocol {
    func getRandomMeals() async throws -> [Meal]
    func getMeals(name: String) async throws -> [Meal]
    func getMeals(ingredient: String) async throws -> [Meal]
    func getMeal(id: String) async throws -> Meal?    
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
}
