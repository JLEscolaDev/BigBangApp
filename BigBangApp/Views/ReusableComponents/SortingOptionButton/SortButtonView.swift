//
//  File.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import SwiftUI

fileprivate struct SortButtonView<Options: CaseIterable & Identifiable & RawRepresentable & Hashable>: ViewModifier where Options.RawValue == String {
    @Binding var sorted: Options
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        ForEach(Array(Options.allCases), id: \.self) { order in
                            Button {
                                sorted = order
                            } label: {
                                HStack {
                                    Text(order.rawValue)
                                    Spacer()
                                    if order == sorted {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Sorted by: \(sorted.rawValue)")
                    }
                }
            }
    }
}

extension View {
    func sortButton(sorted: Binding<OrderOptionsEnum>) -> some View {
        modifier(SortButtonView(sorted: sorted))
    }
}
