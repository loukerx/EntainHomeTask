//
//  CardView.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import SwiftUI
import Combine

struct CardView: View {
    let raceSummary: RaceSummary
    @ObservedObject var homeViewModel: HomeViewModel

    // countdown is the difference from Date().timeIntervalSince1970
    @State private var countdown: TimeInterval
    @State private var cancellable: AnyCancellable? = nil
    
    init(raceSummary: RaceSummary, homeViewModel: HomeViewModel) {
        self.raceSummary = raceSummary
        self.homeViewModel = homeViewModel
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
                    .accessibilityLabel(Text(countdown.formattedVoiceOverDuration()))
            }
        }
        .accessibilityElement(children: .combine)
        .onAppear {
            // Start the timer only when the view appears
            let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            self.cancellable = timer.sink { _ in
                self.countdown -= 1
                // Remove races that are one minute past the advertised start
                if self.countdown.isOneMinutePassed() {
                    self.homeViewModel.fetchRaces()
                }
            }
        }
        .onDisappear {
            // Cancel the timer when the view disappears
            self.cancellable?.cancel()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let mockAdvertisedStart = AdvertisedStart(seconds: 1687046040)
        let mockRaceSummary = RaceSummary(raceId: "1", raceName: "Race 1", raceNumber: 1, meetingId: "1", meetingName: "Meeting 1", categoryId: "1", advertisedStart: mockAdvertisedStart)
        let homeViewModel = HomeViewModel(apiClient: APIClient())
        CardView(raceSummary: mockRaceSummary, homeViewModel: homeViewModel)
            .previewLayout(.sizeThatFits)
    }
}


