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

extension BoredApi: DataProvider {
    func loadActicity(key: String?, type: BoredApi.ActivityType?, participants: Int?, price: BoredApi.ExactOrRange<Double>?, accessibility: BoredApi.ExactOrRange<Int>?) async throws -> BoredApi.Activity {
        try await self.loadActivity(key: key, type: type, participants: participants, price: price, accessibility: accessibility)
    }
}

class LocalDataProvider: DataProvider {
    func loadActicity(key: String? = nil, type: BoredApi.ActivityType? = nil, participants: Int? = nil, price: BoredApi.ExactOrRange<Double>? = nil, accessibility: BoredApi.ExactOrRange<Int>? = nil) async throws -> BoredApi.Activity {
        let rndNumber = Int.random(in: 0..<9999)
        return BoredApi.Activity(activity: "Demo Activity \(rndNumber)", accessibility: Double(rndNumber), type: .busywork, participants: rndNumber, price: Double(rndNumber), link: "no link", key: rndNumber)
    }
}
