//
//  SwiperView.swift
//  BoredApp
//
//  Created by Simon Deutsch on 13.05.24.
//

import SwiftUI

struct SwiperView<Content>: View where Content: View {
    @Binding var offset: CGSize
    @ViewBuilder let content: () -> Content
    @StateObject var viewModel: ViewModel

    init(offset: Binding<CGSize>, swipe: @escaping (SwipeDirection) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self._offset = offset
        self.content = content
        self._viewModel = StateObject(wrappedValue: ViewModel(offset: offset, swipe: swipe))
    }

    var body: some View {
        ZStack {
            content()
        }
        .fixedSize()
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged(viewModel.dragOnchange)
                .onEnded(viewModel.dragOnEnd)
        )
    }
}

#Preview {
    StatefulPreviewWrapper(CGSize.zero) { offset in
        VStack {
            Spacer()
            SwiperView(offset: offset, swipe: { _ in }, content: {
                Rectangle()
                Text("Some Question")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: 300, height: 400)
            })
            Spacer()
            Button("reset") { offset.wrappedValue = .zero }
        }
    }
}
