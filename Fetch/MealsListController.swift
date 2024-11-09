//
//  MealsListController.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import UIKit

class MealsListController: UIViewController {
    
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
