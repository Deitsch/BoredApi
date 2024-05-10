//
//  ContentView.swift
//  BoredApp
//
//  Created by Simon Deutsch on 06.05.24.
//

import SwiftUI
import BoredApi

struct ActivityView: View {

    @EnvironmentObject private var api: BoredApiWrapper
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                switch viewModel.state {
                case .idle:
                    Text("Activity loading")
                case .activity(let activity):
                    ActivityCardView(activity: activity)
                case .error(let error):
                    if case BoredApi.ApiError.noActivityFound = error {
                        Text("No activity found. Try to change filters")
                    }
                    else {
                        Text("An error occured, check your internet connection")
                    }
                }
                Spacer()
                Text(Bundle.version).opacity(0.3)
            }
            .padding()
            .navigationTitle("Activity")
            .onAppear(perform: viewModel.loadActivity)
            .sheet(isPresented: $viewModel.showFilterSheet) { filterSheet }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.showFilter, label: {
                        Image(systemName: viewModel.filterbuttonIcon)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.loadActivity, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                }
            }
        }
    }

    // one could move this out to a seperate view
    @ViewBuilder
    private var filterSheet: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Filter")
                    .font(.largeTitle)
                Toggle("", isOn: $viewModel.filterViewModel.active)
            }
            Spacer()
            TextField("Key", value: $viewModel.filterViewModel.key, format: .number)
            Divider()
            TextField("Participants", value: $viewModel.filterViewModel.participants, format: .number)
            Divider()
            Picker("", selection: $viewModel.filterViewModel.type) {
                Text("Any").tag(nil as ActivityType?)
                ForEach(ActivityType.allCases) { value in
                    Text(value.rawValue.capitalized).tag(value as ActivityType?)
                }
            }
            Divider()
            ExactOrRangePicker(title: "Price", exactOrRange: $viewModel.filterViewModel.price)
            Divider()
            ExactOrRangePicker(title: "Accessibility", exactOrRange: $viewModel.filterViewModel.accessibility)
            Spacer()
        }
        .contentShape(.rect)
        .onTapGesture {
            dismissKeyboard()
        }
        .padding(20)
        .presentationDetents([.medium])
    }
}

#Preview {
    let apiWrapper = BoredApiWrapper(dataProvider: LocalDataProvider())
    let vm = ActivityView.ViewModel(api: apiWrapper)
    return ActivityView(viewModel: vm)
        .environmentObject(apiWrapper)
}
