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

        @Published var key: Int?
        @Published var participants: Int?
        @Published var type: ActivityType?
        @Published var price: ExactOrRange<Double> = .exact(value: nil)
        @Published var accessibility: ExactOrRange<Int> = .exact(value: nil)
    }
}

extension ActivityView {
    enum ViewState {
        case idle
        case activity(Activity)
        case error(Error)
    }
}

extension ActivityView {

    @MainActor
    class ViewModel: ObservableObject {
        @Published var state: ViewState = .idle
        @Published var showFilterSheet = false
        @Published var filterViewModel = FilterViewModel()
        private let api: BoredApiWrapper

        init(api: BoredApiWrapper) {
            self.api = api
        }

        func loadActivity() {
            Task {
                do {
                    let activity: Activity

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
                    state = .activity(activity)
                }
                catch {
                    logger.error(error)
                    state = .error(error)
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
