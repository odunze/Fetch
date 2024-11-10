//
//  Models.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import Foundation

struct MealsResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let name: String
    let thumbnail: String
    let id: String
    var instructions: String?
    var ingredients: [Ingredient]?
    
    struct Ingredient: Codable {
        let name: String
        let measure: String
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case id = "idMeal"
        case instructions = "strInstructions"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        id = try container.decode(String.self, forKey: .id)
        instructions = try? container.decode(String.self, forKey: .instructions)
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
        
        ingredients = try? (1...20).compactMap { index in
            let ingredientKey = DynamicCodingKey(stringValue: "strIngredient\(index)")
            let measureKey = DynamicCodingKey(stringValue: "strMeasure\(index)")
            
            if let ingredientKey = ingredientKey,
               let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey),
               !ingredient.isEmpty,
               let measureKey = measureKey,
               let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey),
               !measure.isEmpty {
                return Ingredient(name: ingredient, measure: measure)
            }
            return nil
        }
    }
}

struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int? { return nil }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}
