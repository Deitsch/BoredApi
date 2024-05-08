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

    @StateObject var api = BoredApiWrapper(dataProvider: BoredApi())

    var body: some Scene {
        WindowGroup {
            ActivityView(viewModel: ActivityView.ViewModel(api: api))
                .environmentObject(api)
        }
    }
}
