//
//  BoredApp.swift
//  BoredApp
//
//  Created by Simon Deutsch on 06.05.24.
//

import SwiftUI
import Logging
import BoredApi


let logger = Logger(label: "io.deitsch.boredapp")

@main
struct BoredApp: App {

    @StateObject var api: BoredApiWrapper

    init() {
        if CommandLine.arguments.contains(where: { $0 == "testMode" }) {
            _api = StateObject(wrappedValue: BoredApiWrapper(dataProvider: LocalDataProvider()))
        }
        else {
            _api = StateObject(wrappedValue: BoredApiWrapper(dataProvider: BoredApi()))
        }
    }

    var body: some Scene {
        WindowGroup {
            ActivityView(viewModel: ActivityView.ViewModel(api: api))
                .environmentObject(api)
        }
    }
}
