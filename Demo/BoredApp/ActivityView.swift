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
                    SwiperView(offset: $viewModel.offset, swipe: viewModel.swipe) {
                        ActivityCardView(activity: activity)
                    }
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
            .navigationTitle("I am Bored")
            .onAppear(perform: viewModel.loadActivityFireAndForget)
            .sheet(isPresented: $viewModel.showFilterSheet) { filterSheet }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.showFilter, label: {
                        Image(systemName: viewModel.filterbuttonIcon)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.loadActivityFireAndForget, label: {
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
                .keyboardType(.numberPad)
            Divider()
            TextField("Participants", value: $viewModel.filterViewModel.participants, format: .number)
                .keyboardType(.numberPad)
            Divider()
            HStack {
                Text("Type")
                Spacer()
                Picker("", selection: $viewModel.filterViewModel.type) {
                    Text("Any").tag(nil as ActivityType?)
                    ForEach(ActivityType.allCases) { value in
                        Text(value.rawValue.capitalized).tag(value as ActivityType?)
                    }
                }
            }
            Divider()
            ExactOrRangePicker("Price", exactOrRange: $viewModel.filterViewModel.price)
                .keyboardType(.numberPad)
            Divider()
            ExactOrRangePicker("Accessibility", exactOrRange: $viewModel.filterViewModel.accessibility)
                .keyboardType(.numberPad)
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
