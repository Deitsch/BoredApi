//
//  BoredApiWrapper.swift
//  BoredApp
//
//  Created by Simon Deutsch on 06.05.24.
//

import Foundation
import BoredApi

typealias RemoteDataProvider = BoredApi
typealias Activity = BoredApi.Activity
typealias ActivityType = BoredApi.ActivityType
typealias ExactOrRange = BoredApi.ExactOrRange

class BoredApiWrapper: ObservableObject {
    private let dataProvider: DataProvider

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func loadActicity(key: Int? = nil, type: BoredApi.ActivityType? = nil, participants: Int? = nil, price: BoredApi.ExactOrRange<Double>? = nil, accessibility: BoredApi.ExactOrRange<Double>? = nil) async throws -> BoredApi.Activity {
        try await dataProvider.loadActicity(key: key, type: type, participants: participants, price: price, accessibility: accessibility )
    }
}

protocol DataProvider {
    func loadActicity(key: Int?, type: BoredApi.ActivityType?, participants: Int?, price: BoredApi.ExactOrRange<Double>?, accessibility: BoredApi.ExactOrRange<Double>?) async throws -> BoredApi.Activity
}

extension BoredApi: DataProvider {
    func loadActicity(key: Int?, type: BoredApi.ActivityType?, participants: Int?, price: BoredApi.ExactOrRange<Double>?, accessibility: BoredApi.ExactOrRange<Double>?) async throws -> BoredApi.Activity {
        try await self.loadActivity(key: key, type: type, participants: participants, price: price, accessibility: accessibility)
    }
}

class LocalDataProvider: DataProvider {
    func loadActicity(key: Int? = nil, type: BoredApi.ActivityType? = nil, participants: Int? = nil, price: BoredApi.ExactOrRange<Double>? = nil, accessibility: BoredApi.ExactOrRange<Double>? = nil) async throws -> BoredApi.Activity {
        let rndNumber = Int.random(in: 0..<9999)
        return BoredApi.Activity(activity: "Demo Activity \(rndNumber)", accessibility: Double(rndNumber * 2), type: .busywork, participants: rndNumber * 2, price: Double(rndNumber * 3), link: "no link", key: rndNumber * 4)
    }
}
