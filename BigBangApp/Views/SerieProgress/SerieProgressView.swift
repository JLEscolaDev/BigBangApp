//
//  SerieProgressView.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 21/4/24.
//

import SwiftUI

struct SerieProgressView: View {
    init(progress: CGFloat) {
        self.progress = progress
    }
    
    @State private var progress: CGFloat
    
    var body: some View {
        CircularProgressView(progress: progress)
            .background() {
                if let image = UIImage(named: "AppIcon") {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }
            }
            .frame(width: 200, height: 200)
        Spacer()
    }
}

#Preview {
    SerieProgressView.preview
}
