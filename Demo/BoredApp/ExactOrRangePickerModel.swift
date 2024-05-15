//
//  ExactOrRangePickerModel.swift
//  BoredApp
//
//  Created by Simon Deutsch on 11.05.24.
//

import SwiftUI

extension ExactOrRangePicker {

    enum Mode: String, CaseIterable, Identifiable {
        case exact, range
        var id: Self { self }
    }

    class ViewModel: ObservableObject {
        @Published var mode: Mode
        let title: LocalizedStringKey
        var exactAdapter: Binding<String>
        var minAdapter: Binding<String>
        var maxAdapter: Binding<String>

        init(exactOrRange: Binding<ExactOrRange<T>>, title: LocalizedStringKey) {
            self.title = title
            self.mode = switch exactOrRange.wrappedValue {
            case .exact: .exact
            case .range: .range
            }
            exactAdapter = Binding(
                get: {
                    if case .exact(let val) = exactOrRange.wrappedValue, let val {
                        return String(val)
                    }
                    return ""
                },
                set: { value in
                    exactOrRange.wrappedValue = .exact(value: T(value))
                })
            minAdapter = Binding(
                get: {
                    if case .range(let min, _) = exactOrRange.wrappedValue, let min {
                        return String(min)
                    }
                    return ""
                },
                set: { value in
                    var oldMax: T?
                    if case .range(_, let max) = exactOrRange.wrappedValue {
                        oldMax = max
                    }
                    exactOrRange.wrappedValue = .range(min: T(value), max: oldMax)
                })
            maxAdapter = Binding(
                get: {
                    if case .range(_, let max) = exactOrRange.wrappedValue, let max {
                        return String(max)
                    }
                    return ""
                },
                set: { value in
                    var oldMin: T?
                    if case .range(let min, _) = exactOrRange.wrappedValue {
                        oldMin = min
                    }
                    exactOrRange.wrappedValue = .range(min: oldMin, max: T(value))
                })

        }
    }
}
