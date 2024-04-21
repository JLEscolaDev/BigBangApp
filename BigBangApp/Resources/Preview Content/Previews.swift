//
//  Previews.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 21/4/24.
//

import SwiftUI

extension MainView {
    static var preview: some View {
        MainView()
            .environmentObject(BigBangVM(interactor: LocalDataInteractor(for: BigBangVM.DevelopmentPhase.dev)))
    }
}

extension EpisodeView {
    static var preview: some View {
        Group {
            if let episode = BigBangVM(interactor: LocalDataInteractor(for: BigBangVM.DevelopmentPhase.dev)).episodesBySeason.first?.value.first {
                EpisodeView(episode: episode)
                    .environmentObject(BigBangVM(interactor: LocalDataInteractor(for: BigBangVM.DevelopmentPhase.dev)))
            } else {
                Text("Failure in the preview. Data missing")
            }
        }
    }
}

extension SerieProgressView {
    static var preview: some View {
        SerieProgressView(progress: 0.25).frame(width: 500, height: 500)
    }
}

extension EpisodeDetail {
    static var preview: some View {
        Group {
            if let episode = BigBangVM(interactor: LocalDataInteractor(for: BigBangVM.DevelopmentPhase.dev)).episodesBySeason.first?.value.first {
                EpisodeDetail(episode: episode)
            } else {
                Text("Failure in the preview. Data missing")
            }
        }
    }
}

extension CircularProgressView {
    static var preview: some View {
        CircularProgressView(progress: 0.25)
    }
}

extension StarRatingView {
    static var preview: some View {
        StarRatingView(
            rating: .constant(2),
            label: "Rate my view"
        )
    }
}

extension RatingView {
    static var preview: some View {
        RatingView(
            rating: .constant(3),
            label: "Rate my view",
            maximumRating: 10,
            offImage: Image(
                systemName: "figure.highintensity.intervaltraining"
            ),
            onImage: Image(
                systemName: "figure.run.circle.fill"
            ),
            offColor: .gray.opacity(
                0.5
            ),
            onColor: .blue
        )
    }
}
