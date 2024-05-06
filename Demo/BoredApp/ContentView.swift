//
//  ContentView.swift
//  BoredApp
//
//  Created by Simon Deutsch on 06.05.24.
//

import SwiftUI
import BoredApi

struct ContentView: View {

    @EnvironmentObject private var api: BoredApiWrapper
    @State private var activity: BoredApi.Activity?

    var body: some View {
        VStack {
            if let activity {
                Text(activity.activity)
            }
            else {
                Text("no activity found")
            }
        }
        .padding()
        .task {
            do {
                activity = try await api.loadActicity()
            }
            catch {
                logger.error(error)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BoredApiWrapper(dataProvider: LocalDataProvider()))
}
