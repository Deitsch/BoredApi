//
//  ExactOrRangePicker.swift
//  BoredApp
//
//  Created by Simon Deutsch on 08.05.24.
//

import SwiftUI

struct ExactOrRangePicker<T: LosslessStringConvertible>: View where T: Equatable {

    let title: LocalizedStringKey
    @Binding var exactOrRange: ExactOrRange<T>
    @StateObject private var viewModel: ViewModel

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
