//
//  ExactOrRangePicker.swift
//  BoredApp
//
//  Created by Simon Deutsch on 08.05.24.
//

import SwiftUI

extension ExactOrRangePicker {

    private enum Mode: String, CaseIterable, Identifiable {
        case exact, range
        var id: Self { self }
    }

    private class ViewModel: ObservableObject {
        @Published var mode: Mode
        var exactAdapter: Binding<String>
        var minAdapter: Binding<String>
        var maxAdapter: Binding<String>

        init(exactOrRange: Binding<ExactOrRange<T>>) {
            mode = switch exactOrRange.wrappedValue {
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

struct ExactOrRangePicker<T: LosslessStringConvertible>: View where T: Equatable {

    let title: LocalizedStringKey
    @Binding var exactOrRange: ExactOrRange<T>
    @StateObject private var viewModel: ViewModel
    @State private var mode: Mode = .exact

    init(title: LocalizedStringKey, exactOrRange: Binding<ExactOrRange<T>>) {
        self.title = title
        self._exactOrRange = exactOrRange
        self._viewModel = StateObject(wrappedValue: ViewModel(exactOrRange: exactOrRange))
    }

    var body: some View {
        VStack {
            HStack {
                Text(title)
                Picker("", selection: $viewModel.mode) {
                    ForEach(Mode.allCases) { value in
                        Text(value.rawValue.capitalized).tag(value)
                    }
                }
            }
            .pickerStyle(.segmented)
            switch viewModel.mode {
            case .exact:
                TextField("Exact", text: viewModel.exactAdapter)
            case .range:
                HStack {
                    TextField("Min", text: viewModel.minAdapter)
                    TextField("Max", text: viewModel.maxAdapter)
                }
            }
        }
    }
}

#Preview {
    VStack {
        ExactOrRangePicker(title: "Some text", exactOrRange: .constant(.exact(value: 1)))
    }
}
