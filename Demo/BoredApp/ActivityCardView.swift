//
//  ActivityCardView.swift
//  BoredApp
//
//  Created by Simon Deutsch on 10.05.24.
//

import SwiftUI

struct ActivityCardView: View {
    
    let activity: Activity

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
            VStack {
                Text(activity.activity)
                    .font(.title2)
                    .accessibilityIdentifier("acticity-name")
                Spacer()
                cardLine(text: "Type", value: activity.type.rawValue.capitalized)
                Divider()
                cardLine(text: "Participants", value: "\(activity.participants)")
                Divider()
                if !activity.link.isEmpty, let url = URL(string: activity.link) {
                    Link(activity.link, destination: url)
                    Divider()
                }
                cardLine(text: "Key", value: "\(activity.key)")
                Divider()
                cardLine(text: "Price", value: "\(activity.price)")
                Divider()
                cardLine(text: "A1ccessibility", value: "\(activity.accessibility)")
                Spacer()
            }
            .padding(20)
        }
        .frame(width: 320, height: 340)
        .shadow(radius: 10)
    }

    @ViewBuilder
    private func cardLine(text: LocalizedStringKey, value: String) -> some View {
        HStack {
            Text(text)
            Spacer()
            Text(value)
        }
    }
}

#Preview {
    ActivityCardView(activity: .preview)
}
