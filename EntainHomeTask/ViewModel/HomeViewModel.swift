//
//  HomeViewModel.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var raceModel: RaceModel?
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchRaces() {
        apiClient.fetchRaces(urlString: APIClient.baseURL)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching races: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { apiResponse in
                self.raceModel = apiResponse.data
            }
            .store(in: &cancellables)
    }

    func refreshData() {
        fetchRaces()
    }

}
