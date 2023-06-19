//
//  TimeIntervalTests.swift
//  EntainHomeTaskTests
//
//  Created by Yin Hua on 19/6/2023.
//

import XCTest
@testable import EntainHomeTask

class TimeIntervalTests: XCTestCase {
    
    func testIsLessThanOneMinutePassed() {
        let timeInterval = Date().timeIntervalSince1970 + 30
        XCTAssertTrue(timeInterval.isLessThanOneMinutePassed())
        
        let timeInterval2 = Date().timeIntervalSince1970 - 70
        XCTAssertFalse(timeInterval2.isLessThanOneMinutePassed())
    }
    
    func testIsOneMinutePassed() {
        let timeInterval = TimeInterval(-70)
        XCTAssertTrue(timeInterval.isOneMinutePassed())
        
        let timeInterval2 = TimeInterval(30)
        XCTAssertFalse(timeInterval2.isOneMinutePassed())
    }
    
    func testGetDuration() {
        let timeInterval = Date().timeIntervalSince1970 + 60
        let duration = timeInterval.getDuration()
        XCTAssertTrue(duration >= 59.9 && duration <= 60.1) // allow for a small time difference
    }
    
    func testFormattedDuration() {
        let timeInterval = 3665.0 // 1 hour, 1 minute and 5 seconds
        XCTAssertEqual(timeInterval.formattedDuration(), "1h 1m 5s")
        
        let timeInterval2 = 65.0 // 1 minute and 5 seconds
        XCTAssertEqual(timeInterval2.formattedDuration(), "1m 5s")
    }
    
    func testFormattedVoiceOverDuration() {
        let timeInterval = 3665.0 // 1 hour, 1 minute and 5 seconds
        XCTAssertEqual(timeInterval.formattedVoiceOverDuration(), "1hour 1minute 5seconds")
        
        let timeInterval2 = 65.0 // 1 minute and 5 seconds
        XCTAssertEqual(timeInterval2.formattedVoiceOverDuration(), "1minute 5seconds")
    }
}
