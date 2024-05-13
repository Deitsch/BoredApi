//
//  Convenience.swift
//  BoredApp
//
//  Created by Simon Deutsch on 06.05.24.
//

import SwiftUI
import Logging
import BoredApi

extension Logger {
    func error(_ error: Error) {
        self.error("\(error.localizedDescription)")
    }
    func error(_ error: NSError) {
        self.error("Domain: \(error.domain), Code: \(error.code), UserInfo: \(error.userInfo)")
    }
}

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Bundle {
    static var version: String {
        let dictionary = Self.main.infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as? String
        let build = dictionary?["CFBundleVersion"] as? String
        return "\(version ?? "noBundleShortVersion") (\(build ?? "noBundleVersion"))"
    }
}

extension ActivityType: Identifiable {
    public var id: Self { self }
}

extension Activity {
    static var preview: Self {
        Activity(activity: "Preview Activity", accessibility: 1, type: .busywork, participants: 2, price: 3, link: "https://www.apple.com", key: 123)
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
