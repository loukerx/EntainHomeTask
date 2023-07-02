//
//  HomeView.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    enum Strings {
        static let loading = "Loading..."
        static let navTitle = "Next to Go"
    }

    var body: some View {
        NavigationView {
            VStack {
                FiltersView(viewModel: viewModel)
                Group {
                    if let raceSummaries = viewModel.filteredRaceSummaries {
                        List(raceSummaries, id: \.raceId) { raceSummary in
                            CardView(raceSummary: raceSummary, homeViewModel:  viewModel)
                        }
                        .refreshable {
                            viewModel.fetchRaces()
                        }
                    } else {
                        ProgressView(Strings.loading)
                    }
                }
            }
            .navigationBarTitle(Strings.navTitle)
            .onAppear {
                viewModel.fetchRaces()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(apiClient: APIClient()))
    }
}

