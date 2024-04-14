//
//  ContentView.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import SwiftUI

struct MainView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @EnvironmentObject private var vm: BigBangVM
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.episodesBySeason.count > 0 {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(vm.episodesBySeason.keys.sorted(), id: \.self) { season in
                                Section(header: HStack {
                                    Text("Season \(season)")
                                    Spacer()
                                    Toggle(isOn: Binding(
                                        get: { self.vm.seasonCheckedState[season] ?? false },
                                        set: { self.vm.seasonCheckedState[season] = $0 }
                                    )) {
                                        Text("Season watched")
                                    }
                                    .toggleStyle(.checkmark)
                                    .padding(.trailing, 5)
                                }) {
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
            .navigationDestination(for: BigBangModel.self) { data in
                Text(data.name) // Adjust this as needed to show detailed view
            }
            .searchable(text: $vm.search)
            .sortButton(sorted: $vm.sorted)
        }
    }
}

#Preview {
    MainView()
}







struct EpisodeView: View {
    let episode: BigBangModel
    @EnvironmentObject private var vm: BigBangVM
    
    @State private var isChecked: Bool = false
    
    var body: some View {
        HStack(spacing: 5) {
            image
            episodeSeenCheckBox
        }.background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isChecked ? .blue : .gray.opacity(0.6), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onChange(of: isChecked) { _, newValue in
            vm.updateEpisodeSeen(newValue, episode: episode)
        }
    }
    
    /// Image that displays the episode image or a placeholder if the image is not available
    private var image: some View {
        getImage(episode.image)
            .resizable()
            .scaledToFill()
            .frame(height: 100)
            .overlay {
                Rectangle().foregroundStyle(.black.opacity(0.7))
            }
            .overlay {
                Text(episode.name)
                    .fontWeight(.bold)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .padding(.all, 10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
    
    /// VStack that holds a custom rounded checkBox and the episode number on top
    private var episodeSeenCheckBox: some View {
        VStack(alignment: .leading) {
            Text(String(episode.number))
                .fontWeight(.semibold)
            Toggle(isOn: $isChecked) {
            }
            .toggleStyle(.checkmark)
            .padding(.trailing, 5)
        }
    }
    
    func getImage(_ imageResourceRef: String) -> Image {
        if let image = UIImage(named: imageResourceRef) {
            return Image(uiImage: image)
        } else {
            return Image(systemName: "photo.tv")
        }
    }
}
