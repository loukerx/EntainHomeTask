//
//  APIClientTests.swift
//  EntainHomeTaskTests
//
//  Created by Yin Hua on 18/6/2023.
//

@testable import EntainHomeTask
import XCTest
import Combine

class APIClientTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []

    func testFetchRacesSuccess() {
        let jsonData = """
        {
            "status": 200,
            "data": {
                "next_to_go_ids": [
                  "7261ed1e-6186-432d-819b-f92d719d8c3b"
                ],
                "race_summaries": {
                  "1358e035-ab89-4a04-93d2-5bed6d45df71": {
                    "race_id": "1358e035-ab89-4a04-93d2-5bed6d45df71",
                    "race_name": "Sportsbet Final (1-4 Wins) (Vicgreys)",
                    "race_number": 5,
                    "meeting_id": "b8dd1fc2-daea-434d-9302-500efe40c499",
                    "meeting_name": "Geelong",
                    "category_id": "9daef0d7-bf3c-4f50-921d-8e818c60fe61",
                    "advertised_start": {
                      "seconds": 1686910620
                    }
                  }
                }
            },
            "message": "Success"
        }
        """.data(using: .utf8)!

        let urlSession = makeMockSession(with: jsonData, statusCode: 200)
    
        let apiClient = APIClient(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Fetch races successfully")
        
        apiClient.fetchRaces(urlString: "https://mockedurl.com")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success, got \(error) instead")
                case .finished:
                    break
                }
            } receiveValue: { apiResponse in
                XCTAssertEqual(apiResponse.status, 200)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func makeMockSession(with data: Data, statusCode: Int) -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        
        let mockUrl = URL(string: "https://mockedurl.com")!
        let response = HTTPURLResponse(url: mockUrl, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        
        MockURLProtocol.stubResponse = (data, response)
        
        return mockSession
    }
}

class MockURLProtocol: URLProtocol {
    
    static var stubResponse: (Data, HTTPURLResponse)?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let (data, response) = MockURLProtocol.stubResponse {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}


