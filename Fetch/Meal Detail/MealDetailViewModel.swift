//
//  MealDetailViewModel.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/9/24.
//

import Foundation

class MealDetailViewModel {
    
    var meal: Meal
    
    init(meal: Meal) {
        self.meal = meal
    }
    
    func loadMealDetails() async throws {
        
        guard let id = Int(meal.id) else { return }
        
        let request = API.meal(id: id).request()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP STATUS CODE: \(httpResponse.statusCode)")
        }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let receivedMeal = try jsonDecoder.decode(Meal.self, from: data)
            meal = receivedMeal
        } catch {
            print("Error decoding data: \(error.localizedDescription)")
            throw error
        }
    }
    
}

