//
//  ExactOrRangePicker.swift
//  BoredApp
//
//  Created by Simon Deutsch on 08.05.24.
//

import SwiftUI

struct ExactOrRangePicker<T: LosslessStringConvertible>: View where T: Equatable {

    @Binding var exactOrRange: ExactOrRange<T>
    @StateObject private var viewModel: ViewModel

    init(_ title: LocalizedStringKey, exactOrRange: Binding<ExactOrRange<T>>) {
        self._exactOrRange = exactOrRange
        self._viewModel = StateObject(wrappedValue: ViewModel(exactOrRange: exactOrRange, title: title))
    }

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                Spacer()
                Picker("", selection: $viewModel.mode) {
                    ForEach(Mode.allCases) { value in
                        Text(value.rawValue.capitalized).tag(value)
                    }
                }
            }
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
        .onChange(of: viewModel.mode) { mode in
            print(mode)
        }
    }
}

#Preview {
    VStack {
        ExactOrRangePicker("Some text", exactOrRange: .constant(.exact(value: 1)))
    }
}
