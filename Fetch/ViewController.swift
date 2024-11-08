//
//  ViewController.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import UIKit

class MealViewController: UIViewController {
    
    private var meal: Meal
    
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var instructionsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var ingredientsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var infoStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = meal.name
        //instructionsLabel.text =
        //ingredientsLabel.text =
        
    }
    
    init(meal: Meal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
        
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(instructionsLabel)
        infoStack.addArrangedSubview(ingredientsLabel)

        view.addSubview(infoStack)
        
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            //infoStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            infoStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

typealias MealsResult = Result<MealsResponse, Error>

class ViewController: UIViewController {
    
    // Meal name
    // Instructions
    // Ingredients/measurements

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        getDesserts { result in
            switch result {
            case .success(let meals):
                print("RECEIVED MEALS: \(meals.meals.count)")
            case .failure(let error):
                print("NETWORK CALL FROM VC WITH ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    //  Asynchronous code must be written using Swift Concurrency (async/await).
    func getDesserts(completion: @escaping(MealsResult) -> Void) {

        let request = API.meal(id: 52792).request()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let serverError = error {
                print("SERVER ERROR: \(serverError.localizedDescription)")
                completion(.failure(serverError))
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP STATUS CODE: \(httpResponse.statusCode)")
            }

            if let receivedData = data {
                do {
//                    let json = try JSONSerialization.jsonObject(with: receivedData, options: [])
//                    print(json)
                    let jsonDecoder = JSONDecoder()

                    let meals = try jsonDecoder.decode(MealsResponse.self, from: receivedData)
                    completion(.success(meals))
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                print("NO DATA RECEIVED")
            }
        }
        task.resume()
    }
}

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
            return "/filter.php"
        case .meal(let id):
            return "/lookup.php"
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
        var components = URLComponents(url: base, resolvingAgainstBaseURL: false)!

        /// Add the endpoint and ? for the query
        components.path = base.path + endpoint.components(separatedBy: "?")[0]

        /// Add the query item for each type of endpoint.
        switch self {
        case .dessert:
            components.queryItems = [URLQueryItem(name: "c", value: "Dessert")]
        case .meal(let id):
            components.queryItems = [URLQueryItem(name: "i", value: "\(id)")]
        }

        guard let url = components.url else {
            fatalError("URL Components are not correct")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
