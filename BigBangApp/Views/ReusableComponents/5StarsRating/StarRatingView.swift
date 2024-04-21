//
//  File.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 15/4/24.
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: UInt8
    
    var label = ""
    var maximumRating:UInt8 = 5
    
    var offImage: Image? = Image(systemName: "star.fill")
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray.opacity(0.3)
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)
            }
            ForEach(1...maximumRating, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = UInt8(number)
                    }
            }
        }
    }
    
    private func image(for number: UInt8) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

#Preview {
    StarRatingView.preview
}
