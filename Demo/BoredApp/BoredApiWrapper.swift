//
//  BoredApiWrapper.swift
//  BoredApp
//
//  Created by Simon Deutsch on 06.05.24.
//

import Foundation
import BoredApi

class BoredApiWrapper: ObservableObject {
    private let dataProvider: DataProvider

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func loadActicity(key: String? = nil, type: BoredApi.ActivityType? = nil, participants: Int? = nil, price: BoredApi.ExactOrRange<Double>? = nil, accessibility: BoredApi.ExactOrRange<Int>? = nil) async throws -> BoredApi.Activity {
        try await dataProvider.loadActicity(key: key, type: type, participants: participants, price: price, accessibility: accessibility )
    }
}

protocol DataProvider {
    func loadActicity(key: String?, type: BoredApi.ActivityType?, participants: Int?, price: BoredApi.ExactOrRange<Double>?, accessibility: BoredApi.ExactOrRange<Int>?) async throws -> BoredApi.Activity
}

typealias RemoteDataProvider = BoredApi 

extension BoredApi: DataProvider {
    func loadActicity(key: String?, type: BoredApi.ActivityType?, participants: Int?, price: BoredApi.ExactOrRange<Double>?, accessibility: BoredApi.ExactOrRange<Int>?) async throws -> BoredApi.Activity {
        try await self.loadActivity(key: key, type: type, participants: participants, price: price, accessibility: accessibility)
    }
}

class LocalDataProvider: DataProvider {
    func loadActicity(key: String? = nil, type: BoredApi.ActivityType? = nil, participants: Int? = nil, price: BoredApi.ExactOrRange<Double>? = nil, accessibility: BoredApi.ExactOrRange<Int>? = nil) async throws -> BoredApi.Activity {
        return BoredApi.Activity(activity: "Demo Activity", accessibility: 1, type: .busywork, participants: 1, price: 1, link: "no link", key: 1)
    }
}
