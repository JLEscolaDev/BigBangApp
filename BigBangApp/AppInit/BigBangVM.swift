//
//  MainViewModel.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import SwiftUI

extension BigBangVM {
    static let shared = LocalDataInteractor(for: DevelopmentPhase.prod)
    
    enum DevelopmentPhase: String, DevelopmentConfigurable {
        case dev = "BigBangTest"
        case prod = "BigBang"
        
        var jsonFileName: String {
            return self.rawValue
        }
    }
}

final class BigBangVM: ObservableObject {
    private let interactor: LocalDataInteractor
    
    init(interactor: LocalDataInteractor = BigBangVM.shared) {
        self.interactor = interactor
        do {
            self.episodes = try interactor.loadDataFromDTO(type: BigBangModelDTO.self)
        } catch {
            self.episodes = []
            print(error)
        }
        for season in Set(episodes.map(\.season)) {
            seasonCheckedState[season] = false
        }
    }
    
    @Published var episodes: [BigBangModel] {
        didSet {
            saveEpisodes()
        }
    }
    @Published var search = ""
    @Published var sorted: OrderOptionsEnum = .bySeasonAsc
    @Published var showFavorites: Bool = false
    @Published var seasonCheckedState: [Int: Bool] = [:]
    
    
    var episodesBySeason: [Int: [BigBangModel]] {
        // Grouping episodes by season
        let grouped = Dictionary(grouping: filteredEpisodes, by: { $0.season })
        
        // Sorting the dictionary by season based on the `sorted` property
        let sortedSeasons = grouped.sorted { season1, season2 in
            switch sorted {
            case .bySeasonAsc:
                return season1.key < season2.key
            case .bySeasonDes:
                return season1.key > season2.key
            default:
                return season1.key < season2.key  // Default to ascending if no valid sorting is provided
            }
        }
        
        // Convert sorted array back to dictionary
        let reDict = Dictionary(uniqueKeysWithValues: sortedSeasons)

        // Sorting the episodes inside each season by their number or other criteria
        return reDict.mapValues { episodes in
            episodes.sorted {
                switch sorted {
                case .byTitleAsc:
                    return $0.name < $1.name
                case .byTitleDes:
                    return $0.name > $1.name
                case .byYearAsc:
                    return $0.airDate < $1.airDate || ($0.airDate == $1.airDate && $0.number < $1.number)
                case .byYearDes:
                    return $0.airDate > $1.airDate || ($0.airDate == $1.airDate && $0.number > $1.number)
                default:
                    return $0.number < $1.number
                }
            }
        }
    }

    
    private var filteredEpisodes: [BigBangModel] {
        episodes.filter { episode in
            if search.isEmpty {
                true
            } else {
                episode.name.localizedStandardContains(search)
            }
        }.filter({ episode in
            if showFavorites {
                episode.favorite
            }else {
                true
            }
        })
    }
    
    func setSeasonSeenStatus(to seenStatus: Bool, forSeason season: Int) {
        // Map over episodes and update the seen status for the specified season by creating new instances.
        episodes = episodes.map { episode in
            guard episode.season == season else { return episode }
            return BigBangModel(
                id: episode.id,
                url: episode.url,
                name: episode.name,
                season: episode.season,
                number: episode.number,
                airDate: episode.airDate,
                runtime: episode.runtime,
                image: episode.image,
                summary: episode.summary,
                favorite: episode.favorite,
                seen: seenStatus,
                comments: episode.comments,
                rating: episode.rating
            )
        }
    }

    
    func getSeasonSeenStatus(season: Int) -> Bool  {
        if let _ = episodesBySeason[season]?.first(where: {$0.seen == false}) {
            false
        } else {
            true
        }
    }
    
    /// Creates an string for display how much episodes have you seen for the selected season. With format: 17/25.
    func getProgressText(for season: Int) -> String {
        "\(episodesBySeason[season]?.filter({$0.seen}).count ?? 0)/\(episodesBySeason[season]?.count ?? 0)"
    }
    
    /// Calculates the total percentage of watched serie
    func getSerieTotalProgress() -> CGFloat {
        let totalEpisodes = episodes.count
        guard totalEpisodes > 0 else { return 0 }
        let watchedEpisodes = episodes.filter({ $0.seen }).count
        return CGFloat(watchedEpisodes) / CGFloat(totalEpisodes)
    }
    
    func updateEpisodeSeen(_ seen: Bool, episode: BigBangModel) {
        let newModel = BigBangModel(
            id: episode.id,
            url: episode.url,
            name: episode.name,
            season: episode.season,
            number: episode.number,
            airDate: episode.airDate,
            runtime: episode.runtime,
            image: episode.image,
            summary: episode.summary,
            favorite: episode.favorite,
            seen: seen,
            comments: episode.comments,
            rating: episode.rating
        )
        updateEpisode(episode: newModel)
    }
    
    func toggleEpisodeFavorite(episode: BigBangModel) {
        let newModel = BigBangModel(
            id: episode.id,
            url: episode.url,
            name: episode.name,
            season: episode.season,
            number: episode.number,
            airDate: episode.airDate,
            runtime: episode.runtime,
            image: episode.image,
            summary: episode.summary,
            favorite: !episode.favorite,
            seen: episode.seen,
            comments: episode.comments,
            rating: episode.rating
        )
        updateEpisode(episode: newModel)
    }
    
    func saveCommentsAndRating(episode: BigBangModel, comments: String, rating: UInt8) {
        let newModel = BigBangModel(
            id: episode.id,
            url: episode.url,
            name: episode.name,
            season: episode.season,
            number: episode.number,
            airDate: episode.airDate,
            runtime: episode.runtime,
            image: episode.image,
            summary: episode.summary,
            favorite: !episode.favorite,
            seen: episode.seen,
            comments: comments,
            rating: rating
        )
        updateEpisode(episode: newModel)
    }
    
    func updateEpisode(episode: BigBangModel) {
        if let index = episodes.firstIndex(where: { $0.id == episode.id }) {
            episodes[index] = episode
        }
    }
    
    func saveEpisodes() {
        do {
            try interactor.saveData(data: episodes)
        } catch {
            print("Error en la grabación: \(error).")
        }
    }
}
