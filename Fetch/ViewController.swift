//
//  ViewController.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import UIKit

class ViewController: UIViewController {
    
    // Meal name
    // Instructions
    // Ingredients/measurements
    //  Asynchronous code must be written using Swift Concurrency (async/await).

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

struct MealsResult: Codable {
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

enum API {
    //  https://themealdb.com/api.php

    case dessert
    case meal(id: Int)

    var base: URL {
        return URL(string: "https://themealdb.com/api/json/v1/1")!
    }

    var endpoint: String {
        switch self {
        case .dessert:
            return "/filter.php?c=Dessert"
        case .meal(let id):
            return "/lookup.php?i=\(id)"
        }
    }

    var method: String {
        switch self {
        default: return "GET"
        }
    }

    var headers: [String: String] {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }

    var body: Data? {
        switch self {
        default: return nil
        }
    }

    func request() -> URLRequest {
        var request = URLRequest(url: base.appendingPathComponent(endpoint))
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
