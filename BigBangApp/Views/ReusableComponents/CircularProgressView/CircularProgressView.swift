//
//  CircularProgressView.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 21/4/24.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: CGFloat
    
    var body: some View {
        ZStack {
            backgroundCircle
            backgroundProgressCircle
        }
    }
    
    var backgroundCircle: some View {
        Circle()
            .stroke(lineWidth: 20)
            .opacity(0.1)
            .foregroundColor(.green)
    }
    
    var backgroundProgressCircle: some View {
        Circle()
            .trim(from: 0.0, to: min(progress, 1.0))
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
            .foregroundColor(.green)
            .rotationEffect(Angle(degrees: 270.0))
            .animation(.linear, value: progress)
    }
}


#Preview {
    CircularProgressView.preview
}
