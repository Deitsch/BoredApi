//
//  SwiperView.swift
//  BoredApp
//
//  Created by Simon Deutsch on 13.05.24.
//

import SwiftUI

enum SwipeDirection {
    case left, right
}

private extension SwipeDirection {
    static func fromWidth(width: CGFloat) -> SwipeDirection? {
        switch width {
        case -500...(-150): .left
        case 150...500: .right
        default: .none
        }
    }
}

extension SwiperView {
    class ViewModel: ObservableObject {
        var offset: Binding<CGSize>
        var swipe: (SwipeDirection) -> Void

        init(offset: Binding<CGSize>, swipe: @escaping (SwipeDirection) -> Void) {
            self.offset = offset
            self.swipe = swipe
        }

        private var direction: SwipeDirection? {
            SwipeDirection.fromWidth(width: offset.wrappedValue.width)
        }

        func dragOnchange(gesture: DragGesture.Value) {
            offset.wrappedValue = gesture.translation
        }

        func dragOnEnd(gesture: DragGesture.Value) {
            if #available(iOS 17.0, *) {
                withAnimation {
                    swipeCard(direction: direction)
                } completion: {
                    guard let direction = self.direction else { return }
                    self.swipe(direction)
                }
            } else {
                // TODO: Fallback on earlier versions
                // can be done with withAnimation with fixed time and Dispatch/delayed run code
            }
        }

        private func swipeCard(direction: SwipeDirection?) {
            offset.wrappedValue = switch direction {
            case .left: CGSize(width: -500, height: 0)
            case .right: CGSize(width: 500, height: 0)
            case .none: .zero
            }
        }
    }
}

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
    StatefulPreviewWrapper(CGSize.zero) {
        SwiperView(offset: $0, swipe: { _ in }) {
            Rectangle()
            Text("Some Question")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .frame(width: 300, height: 400)
        }
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
