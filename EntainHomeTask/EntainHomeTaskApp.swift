//
//  EntainHomeTaskApp.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import SwiftUI

@main
struct EntainHomeTaskApp: App {
    var body: some Scene {
        WindowGroup {
            let apiClient = APIClient()
            let homeViewModel = HomeViewModel(apiClient: apiClient)
            HomeView(viewModel: homeViewModel)
        }
    }
}
