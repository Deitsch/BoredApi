//
//  ContentView.swift
//  BoredApp
//
//  Created by Simon Deutsch on 06.05.24.
//

import SwiftUI
import BoredApi


extension ActivityView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var activity: Activity?
        @Published var showFilterSheet = false
        private let api: BoredApiWrapper

        init(api: BoredApiWrapper) {
            self.api = api
        }

        func loadActivity() {
            Task {
                do {
                    activity = try await api.loadActicity()
                }
                catch {
                    logger.error(error)
                }
            }
        }

        var filterbuttonIcon: String {
            showFilterSheet
                ? "line.3.horizontal.decrease.circle.fill"
                : "line.3.horizontal.decrease.circle"
        }

        func showFilter() {
            showFilterSheet = true
        }
    }
}

struct ActivityView: View {

    @EnvironmentObject private var api: BoredApiWrapper
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            VStack {
                if let activity = viewModel.activity {
                    Text(activity.activity)
                }
                else {
                    Text("no activity found")
                }
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

    @ViewBuilder
    var filterSheet: some View {
        Text("filter sheet")
    }
}

#Preview {
    let apiWrapper = BoredApiWrapper(dataProvider: LocalDataProvider())
    let vm = ActivityView.ViewModel(api: apiWrapper)
    return ActivityView(viewModel: vm)
        .environmentObject(apiWrapper)
}
