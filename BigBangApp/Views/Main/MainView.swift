//
//  ContentView.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//


import SwiftUI

struct MainView: View {
    @State private var width: CGFloat = 0
    var columns: [GridItem] {
        let count = width > 600 ? 3 : 2
        return Array(repeating: .init(.flexible()), count: count)
    }
    
    @EnvironmentObject private var vm: BigBangVM
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                Group {
                    if vm.episodesBySeason.count > 0 {
                        bigBangSeriesList
                    } else if !vm.search.isEmpty {
                        ContentUnavailableView("No episodes found",
                                               systemImage: "movieclapper",
                                               description: Text("There's no episodes that contains the string '**\(vm.search)**'."))
                    } else {
                        ContentUnavailableView("No episodes found",
                                               systemImage: "movieclapper")
                    }
                }
                .navigationTitle("Big Bang Episodes")
                .navigationDestination(for: BigBangModel.self) { episode in
                    EpisodeDetail(episode: episode)
                }
                .searchable(text: $vm.search)
                .sortButton(sorted: $vm.sorted)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            vm.showFavorites.toggle()
                        }, label: {
                            Image(systemName: "star.fill").foregroundStyle(.yellow)
                        })
                        
                    }
                }
            }.onAppear {
                width = geometry.size.width
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                width = newWidth
            }
        }
    }
    
    private var bigBangSeriesList: ScrollView<some View> {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(vm.episodesBySeason.keys.sorted(), id: \.self) { season in
                    Section(header:
                        HStack {
                            Text("Season \(season)")
                            Spacer()
                        if !vm.showFavorites { // Disable the all episodes seen when displaying the favorites.
                            Toggle(isOn: Binding(
                                get: {vm.getSeasonSeenStatus(season: season)},
                                set: {vm.setSeasonSeenStatus(to: $0, forSeason: season)}
                            )) {
                                Text("Season watched")
                            }
                            .toggleStyle(.checkmark)
                            .padding(.trailing, 5)
                        }
                        }.padding(.vertical, 10)
                    ) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(vm.episodesBySeason[season] ?? [], id: \.self) { episode in
                                NavigationLink(value: episode) {
                                    EpisodeView(episode: episode)
                                }
                            }
                        }
                    }
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    MainView()
}
