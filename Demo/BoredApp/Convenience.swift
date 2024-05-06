//
//  Convenience.swift
//  BoredApp
//
//  Created by Simon Deutsch on 06.05.24.
//

import SwiftUI
import Logging

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
