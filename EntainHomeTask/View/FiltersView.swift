//
//  FiltersView.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 18/6/2023.
//

import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: HomeViewModel

    @State private var selectedOptions: Set<String> = []
    @State private var isOptionASelected: Bool = false
    @State private var isOptionBSelected: Bool = false
    @State private var isOptionCSelected: Bool = false

    var body: some View {
        // Filters
        VStack {
            Toggle(HomeViewModel.Category.greyhound.name, isOn: $isOptionASelected)
                .onChange(of: isOptionASelected) { isSelected in
                    updateSelectedOptions(HomeViewModel.Category.greyhound.categoryID, isSelected: isSelected)
                }

            Toggle(HomeViewModel.Category.harness.name, isOn: $isOptionBSelected)
                .onChange(of: isOptionBSelected) { isSelected in
                    updateSelectedOptions(HomeViewModel.Category.harness.categoryID, isSelected: isSelected)
                }

            Toggle(HomeViewModel.Category.horse.name, isOn: $isOptionCSelected)
                .onChange(of: isOptionCSelected) { isSelected in
                    updateSelectedOptions(HomeViewModel.Category.horse.categoryID, isSelected: isSelected)
                }
        }
        .padding()
    }
    
    private func updateSelectedOptions(_ option: String, isSelected: Bool) {
        if isSelected {
            selectedOptions.insert(option)
        } else {
            selectedOptions.remove(option)
        }
        viewModel.filterRaceSummaries(by: selectedOptions)
    }
}


struct FiltersViews_Preview: PreviewProvider {
    static var previews: some View {
        FiltersView(viewModel: HomeViewModel(apiClient: APIClient()))
    }
}
