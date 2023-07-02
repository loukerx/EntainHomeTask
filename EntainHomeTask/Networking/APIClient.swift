//
//  APIClient.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import Foundation
import Combine

protocol APIClientProtocol {
    func fetchRaces(urlString: String) -> AnyPublisher<ApiResponse, Error>
}

struct APIClient: APIClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchRaces(urlString: String) -> AnyPublisher<ApiResponse, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                       .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
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
