//
//  ActivityViewModel.swift
//  BoredApp
//
//  Created by Simon Deutsch on 10.05.24.
//

import Foundation

extension ActivityView {
    class FilterViewModel: ObservableObject {
        @Published var active = false

        @Published var key: String = ""
        @Published var participants: Int?
        @Published var type: ActivityType?
        @Published var price: ExactOrRange<Double> = .exact(value: nil)
        @Published var accessibility: ExactOrRange<Int> = .exact(value: nil)
    }
}

extension ActivityView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var activity: Activity?
        @Published var showFilterSheet = false
        @Published var filterViewModel = FilterViewModel()
        private let api: BoredApiWrapper

        init(api: BoredApiWrapper) {
            self.api = api
        }

        func loadActivity() {
            Task {
                do {
                    if filterViewModel.active {
                        activity = try await api.loadActicity(
                            key: filterViewModel.key,
                            type: filterViewModel.type,
                            participants: filterViewModel.participants,
                            price: filterViewModel.price,
                            accessibility: filterViewModel.accessibility
                        )
                    }
                    else {
                        activity = try await api.loadActicity()
                    }
                }
                catch {
                    logger.error(error)
                }
            }
        }

        var filterbuttonIcon: String {
            filterViewModel.active
                ? "line.3.horizontal.decrease.circle.fill"
                : "line.3.horizontal.decrease.circle"
        }

        func showFilter() {
            showFilterSheet = true
        }
    }
}
