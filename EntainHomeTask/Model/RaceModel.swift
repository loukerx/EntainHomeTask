//
//  RaceModel.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//


import Foundation

struct ApiResponse: Codable {
    let status: Int
    let data: RaceModel
    let message: String
}

struct RaceModel: Codable {
    let nextToGoIds: [String]
    let raceSummaries: [String: RaceSummary]

    enum CodingKeys: String, CodingKey {
        case nextToGoIds = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}

// let raceForm: RaceForm
// Which is not been used. The hometask doesn't require that part.

struct RaceSummary: Codable {
    let raceId: String
    let raceName: String
    let raceNumber: Int
    let meetingId: String
    let meetingName: String
    let categoryId: String
    let advertisedStart: AdvertisedStart
    let venueId: String
    let venueName: String
    let venueState: String
    let venueCountry: String

    enum CodingKeys: String, CodingKey {
        case raceId = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingId = "meeting_id"
        case meetingName = "meeting_name"
        case categoryId = "category_id"
        case advertisedStart = "advertised_start"
        case venueId = "venue_id"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }
}

struct AdvertisedStart: Codable {
    let seconds: TimeInterval
}
