//
//  EpisodeDetail.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 15/4/24.
//

import SwiftUI

struct EpisodeDetail: View {
    init(episode: BigBangModel) {
        self.episode = episode
        self._rating = .init(initialValue: episode.rating)
        self._inputText = .init(initialValue: episode.comments)
        self._isFavorite = .init(initialValue: episode.favorite)
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: BigBangVM
    @State private var rating: UInt8 = 0
    @State private var inputText: String = ""
    @State private var isFavorite: Bool
    
    let episode: BigBangModel
    
    var body: some View {
        VStack {
            episodeImage
            episodeTitle
            comments
            StarRatingView(rating: $rating)
            saveButton
            Spacer()
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    vm.toggleEpisodeFavorite(episode: episode)
                    isFavorite.toggle()
                }, label: {
                    if isFavorite {
                        Image(systemName: "star.slash")
                            .foregroundStyle(.red)
                    } else {
                        Image(systemName: "star")
                            .foregroundStyle(.yellow)
                    }
                })
                
            }
        }
    }
    
    private var episodeImage: some View {
        Image(episode.image)
            .resizable()
            .scaledToFill()
            .frame(height: 300)
            .padding(.bottom, 30)
    }
    
    private var episodeTitle: some View {
        Text(episode.name)
            .font(.title)
    }
    
    private var comments: some View {
        VStack {
            TextField("Describe yourself", text: $inputText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(5, reservesSpace: true)
        }
        .padding()
    }
    
    private var saveButton: some View {
        Button(action: {
            vm.saveCommentsAndRating(episode: episode, comments: inputText, rating: rating)
            dismiss()
        }, label: {
            Text("Save review and comments")
        }).frame(height: 50)
            .padding()
            .buttonStyle(.borderedProminent)
    }
}

#Preview {
    EpisodeDetail.preview
}
