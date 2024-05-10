//
//  ExactOrRangePicker.swift
//  BoredApp
//
//  Created by Simon Deutsch on 08.05.24.
//

import SwiftUI

extension ExactOrRangePicker {
    
    private class ViewModel: ObservableObject {
        @Published var mode: Mode = .range

        @Published var min = ""
        @Published var max = ""
        @Published var exact = ""
    }

    private enum Mode: String, CaseIterable, Identifiable {
        case exact, range
        var id: Self { self }
    }
}

struct ExactOrRangePicker<T: LosslessStringConvertible>: View {

    let title: LocalizedStringKey
    @Binding var exactOrRange: ExactOrRange<T>
    @StateObject private var viewModel = ViewModel()

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
                TextField("Exact", text: $viewModel.exact)
            case .range:
                HStack {
                    TextField("Min", text: $viewModel.min)
                    TextField("Max", text: $viewModel.max)
                }
            }
        }

        // TODO: refactor this into custom Binding
        .onChange(of: viewModel.min, perform: updateExactOrRangeBinding)
        .onChange(of: viewModel.max, perform: updateExactOrRangeBinding)
        .onChange(of: viewModel.exact, perform: updateExactOrRangeBinding)
        .onAppear {
            switch exactOrRange {
            case .exact(let value):
                viewModel.exact = String(value)
            case .range(let min, let max):
                viewModel.min = String(min)
                viewModel.max = String(max)
            }
        }
    }

    func updateExactOrRangeBinding(_ any: Any) {
        exactOrRange = viewModel.mode == .exact
        ? .exact(value: T(viewModel.exact))
        : .range(min: T(viewModel.min), max: T(viewModel.max))
    }
}

#Preview {
    VStack {
        ExactOrRangePicker(title: "Some text", exactOrRange: .constant(.exact(value: 1)))
    }
}

private extension Optional {
    init?(_ description: String?) {
        if let description {
            self.init(description)
        }
        return nil
    }
}

private extension String {
    init(_ llsc: LosslessStringConvertible?) {
        if let llsc {
            self.init(llsc)
        }
        self.init("")
    }
}
