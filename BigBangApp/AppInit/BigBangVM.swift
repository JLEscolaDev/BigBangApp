//
//  MainViewModel.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import SwiftUI


let bigBangDataShared = LocalDataInteractor(jsonFileName: "BigBang")


final class BigBangVM: ObservableObject {
    private let interactor: LocalDataInteractor
    
    @Published var episodes: [BigBangModel] {
        didSet {
            saveEpisodes()
        }
    }
    @Published var search = ""
    @Published var sorted: OrderOptionsEnum = .bySeasonAsc
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
        }
    }
    
    init(interactor: LocalDataInteractor = bigBangDataShared) {
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
    
//    func deleteEpisode(indexSet: IndexSet) {
//        episodes.remove(atOffsets: indexSet)
//    }
//    
//    func moveEpisode(indexSet: IndexSet, to: Int) {
//        episodes.move(fromOffsets: indexSet, toOffset: to)
//    }
    
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
            seen: seen
        )
        updateEpisode(episode: newModel)
    }
    
    func updateEpisode(episode: BigBangModel) {
        if let index = episodes.firstIndex(where: { $0.id == episode.id }) {
            print(episode)
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
