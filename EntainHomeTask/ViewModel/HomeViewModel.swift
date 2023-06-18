//
//  HomeViewModel.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var filteredRaceSummaries: [RaceSummary]?
    private var raceSummaries: [RaceSummary]?
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient
    private var categoryIds: Set<String> = []
    
    enum Category {
        case greyhound
        case harness
        case horse
        
        var name: String {
            switch self {
            case .greyhound:
                return "Greyhound racing"
            case .harness:
                return "Harness racing"
            case .horse:
                return "Horse racing"
            }
        }
        
        var categoryID: String {
            switch self {
            case .greyhound:
                return "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
            case .harness:
                return "161d9be2-e909-4326-8c2c-35ed71fb460b"
            case .horse:
                return "4a2788f8-e825-4d36-9894-efd4baf1cfae"
            }
        }
    }
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchRaces() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String else {
            print("API URL not found in Info.plist")
            return
        }
        print("fetchRaces called")
        apiClient.fetchRaces(urlString: baseURL)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching races: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] apiResponse in
                guard let self , let raceSummaries = apiResponse.data.raceSummaries else { return }
                print("There are \(raceSummaries.count) raceSummaries in the APIResponse")
                updateRaceSummaries(raceSummaries: raceSummaries)
                self.filterRaceSummaries(by: categoryIds)
            }
            .store(in: &cancellables)
    }

    private func updateRaceSummaries(raceSummaries: [String: RaceSummary]) {
        // ordered by advertised start ascending
        self.raceSummaries = raceSummaries.values.sorted {
            let time1 = $0.advertisedStart.seconds
            let time2 = $1.advertisedStart.seconds
            return time1 < time2
        }.filter{ $0.advertisedStart.seconds.isLessThanOneMinutePassed() }
    }
    
    func filterRaceSummaries(by categoryIds: Set<String>) {
        self.categoryIds = categoryIds
        if categoryIds.isEmpty {
            // Get first five raceSummaries
            filteredRaceSummaries = Array(raceSummaries?.prefix(5) ?? [])
        } else {
            filteredRaceSummaries = raceSummaries?.filter{ categoryIds.contains($0.categoryId) }
        }
    }
}
