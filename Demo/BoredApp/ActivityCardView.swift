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
                Divider()
                Text(activity.type.rawValue.capitalized)
                Divider()
                Text(activity.participants, format: .number)
                Divider()
                if !activity.link.isEmpty, let url = URL(string: activity.link) {
                    Link(activity.link, destination: url)
                    Divider()
                }
                Text(activity.key, format: .number)
                Divider()
                Text(activity.price, format: .number)
            }
            .padding(20)
        }
        .frame(width: 320, height: 300)
        .shadow(radius: 10)
        .padding(20)
    }
}

#Preview {
    ActivityCardView(activity: .preview)
}
