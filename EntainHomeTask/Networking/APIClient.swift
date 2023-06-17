//
//  APIClient.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import Foundation
import Combine

struct APIClient {
    // move to plist
    static let baseURL = "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10"
    
    // pass in baseURL, for testing
    func fetchRaces(urlString: String) -> AnyPublisher<ApiResponse, Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
