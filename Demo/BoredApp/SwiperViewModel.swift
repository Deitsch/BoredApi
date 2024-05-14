//
//  SwiperViewModel.swift
//  BoredApp
//
//  Created by Simon Deutsch on 13.05.24.
//

import SwiftUI

enum SwipeDirection {
    case left, right

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

        func dragOnchange(gesture: DragGesture.Value) {
            offset.wrappedValue = gesture.translation
        }

        func dragOnEnd(gesture: DragGesture.Value) {
            let direction = SwipeDirection.fromWidth(width: gesture.translation.width)
            if #available(iOS 17.0, *) {
                withAnimation {
                    swipeCard(direction: direction)
                } completion: {
                    guard let direction = direction else { return }
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
