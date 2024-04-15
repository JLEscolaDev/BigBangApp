//
//  EpisodeDetail.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 15/4/24.
//

import SwiftUI

struct EpisodeDetail: View {
    @EnvironmentObject private var vm: BigBangVM
    @State private var rating: Int = 0
    @State private var inputText: String = ""
    
    let episode: BigBangModel
    
    var body: some View {
        VStack {
            Image(episode.image)
                .resizable()
                .scaledToFill()
                .frame(width: .infinity, height: 300)
                .padding(.bottom, 30)
            Text(episode.name)
                .font(.title)
            VStack {
                TextField("Describe yourself", text: $inputText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5, reservesSpace: true)
            }
            .padding()
            StarRatingView(rating: $rating)
            Button(action: {
                vm.toggleEpisodeFavorite(episode: episode)
            }, label: {
                Text("Save review and comments")
            })
            Spacer()
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    vm.toggleEpisodeFavorite(episode: episode)
                }, label: {
                    if episode.favorite {
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
}

//#Preview {
//    EpisodeDetail(rating: 3, episode: )
//}
