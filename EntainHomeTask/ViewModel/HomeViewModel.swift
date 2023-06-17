//
//  HomeViewModel.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
//    @Published var raceModel: RaceModel?
    @Published var raceSummaries: [RaceSummary]?
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchRaces() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String else {
            print("API URL not found in Info.plist")
            return
        }

        apiClient.fetchRaces(urlString: baseURL)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching races: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { apiResponse in
                let raceSummaries = apiResponse.data.raceSummaries
                // ordered by advertised start ascending
                self.raceSummaries = raceSummaries.values.sorted {
                    let time1 = $0.advertisedStart.seconds
                    let time2 = $1.advertisedStart.seconds
                    return time1 < time2
                }
            }
            .store(in: &cancellables)
    }

    func refreshData() {
        fetchRaces()
    }
}
