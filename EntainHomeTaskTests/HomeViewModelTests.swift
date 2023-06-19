//
//  HomeViewModelTests.swift
//  EntainHomeTaskTests
//
//  Created by Yin Hua on 18/6/2023.
//

import XCTest
import Combine
@testable import EntainHomeTask // Change this to your app's module name

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        let mockAPIClient = MockAPIClient()
        viewModel = HomeViewModel(apiClient: mockAPIClient)
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchRaces() {
        let expectation = XCTestExpectation(description: "Fetching Races")
        
        viewModel.$filteredRaceSummaries
            .dropFirst()
            .sink { filteredRaceSummaries in
                if let filteredRaceSummaries {
                    expectation.fulfill()
                    XCTAssertTrue(filteredRaceSummaries.count == 2)
                    XCTAssertTrue(filteredRaceSummaries[0].advertisedStart.seconds < filteredRaceSummaries[1].advertisedStart.seconds)
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchRaces()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilterRaceSummaries() {
        viewModel.raceSummaries = loadMockRaceSummaryData()
        
        // Test filtering by specific categories
        let categoryIds: Set<String> = ["9daef0d7-bf3c-4f50-921d-8e818c60fe61"]
        viewModel.filterRaceSummaries(by: categoryIds)
        
        // Check if the filteredRaceSummaries contain only the filtered categories
        XCTAssertNotNil(viewModel.filteredRaceSummaries, "filteredRaceSummaries should not be nil")
        if let filteredRaceSummaries = viewModel.filteredRaceSummaries {
            XCTAssertTrue(filteredRaceSummaries.allSatisfy { categoryIds.contains($0.categoryId) }, "All filteredRaceSummaries should have categoryIds within the specified set")
        }
    }
    
    func testFilterRaceSummariesWithEmptycategoryIds() {
        viewModel.raceSummaries = loadMockRaceSummaryData()
        
        let categoryIds: Set<String> = []
        viewModel.filterRaceSummaries(by: categoryIds)
        
        XCTAssertEqual(viewModel.filteredRaceSummaries?.count, 5)
    }

}

class MockAPIClient: APIClientProtocol {

    func fetchRaces(urlString: String) -> AnyPublisher<ApiResponse, Error> {
        let advertisedStart = AdvertisedStart(seconds:  Date().timeIntervalSince1970 + 120)
        let advertisedStart2 = AdvertisedStart(seconds: Date().timeIntervalSince1970 + 110)
        let advertisedStart3 = AdvertisedStart(seconds: Date().timeIntervalSince1970 - 100)
        
        let raceSummary = RaceSummary(
            raceId: "sample_race_id",
            raceName: "Sample Race",
            raceNumber: 1,
            meetingId: "sample_meeting_id",
            meetingName: "Sample Meeting",
            categoryId: "sample_category_id",
            advertisedStart: advertisedStart
        )

        let raceSummary2 = RaceSummary(
            raceId: "sample_race_id2",
            raceName: "Sample Race2",
            raceNumber: 5,
            meetingId: "sample_meeting_id2",
            meetingName: "Sample Meeting2",
            categoryId: "sample_category_id2",
            advertisedStart: advertisedStart2
        )
        
        let raceSummary3 = RaceSummary(
            raceId: "sample_race_id3",
            raceName: "Sample Race3",
            raceNumber: 7,
            meetingId: "sample_meeting_id3",
            meetingName: "Sample Meeting3",
            categoryId: "sample_category_id3",
            advertisedStart: advertisedStart3
        )

        let raceModel = RaceModel(
            nextToGoIds: ["sample_next_to_go_id"],
            raceSummaries: ["sample_race_id": raceSummary, "sample_race_id2": raceSummary2, "sample_race_id3": raceSummary3]
        )
        
        let mockApiResponse = ApiResponse(
            status: 200,
            data: raceModel,
            message: "Success"
        )
        
        return Just(mockApiResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

extension HomeViewModelTests {
    func loadMockRaceSummaryData() -> [RaceSummary]? {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: "RaceSummaryMockData", withExtension: "json") else {
            print("Failed to locate RaceSummaryMockData.json")
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let raceSummaries = try decoder.decode([RaceSummary].self, from: jsonData)
            
            return raceSummaries
        } catch {
            print("Error loading race data: \(error)")
            return nil
        }
    }
}
