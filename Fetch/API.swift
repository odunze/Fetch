//
//  API.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import Foundation

enum API {

    case dessert
    case meal(id: Int)

    var base: URL {
        return URL(string: "https://themealdb.com/api/json/v1/1")!
    }

    var endpoint: String {
        switch self {
        case .dessert:
            return "/filter.php"
        case .meal:
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
