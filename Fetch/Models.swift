//
//  Models.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import Foundation

typealias MealsResult = Result<MealsResponse, Error>

struct MealsResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let name: String
    let thumbnail: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case id = "idMeal"
    }
}
