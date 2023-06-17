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
            Group {
                if let raceModel = viewModel.raceModel {
                    List {
                        ForEach(raceModel.raceSummaries.keys.sorted(), id: \.self) { key in
                            if let raceSummary = raceModel.raceSummaries[key] {
                                CardView(raceSummary: raceSummary)
                            }
                        }
                    }
                    .refreshable {
                        viewModel.refreshData()
                    }
                } else {
                    ProgressView(Strings.loading)
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

