//
//  CardView.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import SwiftUI

struct CardView: View {
    let raceSummary: RaceSummary
    @State private var countdown: TimeInterval
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(raceSummary: RaceSummary) {
        self.raceSummary = raceSummary
        let duration = raceSummary.advertisedStart.seconds.getDuration()
        self._countdown = State(initialValue: duration)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(raceSummary.meetingName)
                .font(.title)
                .fontWeight(.bold)
            HStack {
                Text("Race number: \(raceSummary.raceNumber)")
                    .font(.body)
                Spacer()
                Text(countdown.formattedDuration())
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.trailing)
            }
        }
        .onReceive(timer) { _ in
            if self.countdown > 0 {
                self.countdown -= 1
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let mockAdvertisedStart = AdvertisedStart(seconds: 1687010980)
        let mockRaceSummary = RaceSummary(raceId: "1", raceName: "Race 1", raceNumber: 1, meetingId: "1", meetingName: "Meeting 1", categoryId: "1", advertisedStart: mockAdvertisedStart, venueId: "1", venueName: "Venue 1", venueState: "State 1", venueCountry: "Country 1")
        
        CardView(raceSummary: mockRaceSummary)
            .previewLayout(.sizeThatFits)
    }
}


