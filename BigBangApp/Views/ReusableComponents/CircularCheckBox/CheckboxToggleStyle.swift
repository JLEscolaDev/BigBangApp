//
//  File.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .overlay {
                    Image(systemName: configuration.isOn ? "checkmark" : "")
                }
                .onTapGesture {
                    configuration.isOn.toggle()
                }
                .foregroundStyle(configuration.isOn ? .blue : .gray.opacity(0.6))
 
            configuration.label
 
        }
    }
}


extension ToggleStyle where Self == CheckboxToggleStyle {
    /// Convenience checkbox style with a circle toggle instead of a rectangle
    static var checkmark: CheckboxToggleStyle { CheckboxToggleStyle() }
}
