//
//  MealsListViewModel.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import Foundation

class MealsListViewModel {
    
    var meals: [Meal] = []
    
    func loadDesserts() async throws {
        let request = API.dessert.request()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP STATUS CODE: \(httpResponse.statusCode)")
        }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let mealList = try jsonDecoder.decode(MealsResponse.self, from: data)
            meals = mealList.meals
        } catch {
            print("Error decoding data: \(error.localizedDescription)")
            throw error
        }
    }
}