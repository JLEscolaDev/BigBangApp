//
//  RatingView.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 15/4/24.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray.opacity(0.5)
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
                        rating = number
                    }
            }
        }
    }
    
    private func image(for number: Int) -> Image {
        let starImage: Image
        if number > rating {
            starImage = offImage ?? onImage
        } else {
            starImage = onImage
        }
        return starImage.renderingMode(.template)
    }
}

#Preview {
    RatingView(
        rating: .constant(2),
        label: "Rate my view",
        maximumRating: 5,
        offImage: Image(
            systemName: "star"
        ),
        onImage: Image(
            systemName: "star.fill"
        ),
        offColor: .gray.opacity(
            0.5
        ),
        onColor: .yellow
    )
}
