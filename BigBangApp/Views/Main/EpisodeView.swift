//
//  EpisodeView.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 15/4/24.
//

import SwiftUI

struct EpisodeView: View {
    let episode: BigBangModel
    @EnvironmentObject private var vm: BigBangVM
    
    @State var isChecked: Bool
    
    init(episode: BigBangModel) {
        self.episode = episode
        self._isChecked = .init(initialValue: episode.seen)
    }
    
    var body: some View {
        HStack(spacing: 5) {
            image
            episodeSeenCheckBox
        }.background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(episode.seen ? .blue : .gray.opacity(0.6), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
    }
    
    /// Image that displays the episode image or a placeholder if the image is not available
    private var image: some View {
        getImage(episode.image)
            .resizable()
            .frame(minWidth: 0, maxWidth: .infinity) // Ensures the cell takes up as much width as possible
            .aspectRatio(1/1, contentMode: .fill) // Ensures the cell proportion to not overlap with the other cells
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
            .frame(height: 110)
    }
    
    /// VStack that holds a custom rounded checkBox and the episode number on top
    private var episodeSeenCheckBox: some View {
        VStack(alignment: .leading) {
            Text(String(episode.number))
                .fontWeight(.semibold)
//            Button(action: {
//                vm.toggleSeen(episode: episode)
//            }, label: {
//                Text("update")
//                    .foregroundStyle(episode.seen ? .green : .gray)
//
//            })
//            if let seenStatus = vm.toggleSeen(vm: $vm, episode: episode) {
//                Toggle(isOn: seenStatus) {
//                    
//                }
//                .toggleStyle(.checkmark)
//                .padding(.trailing, 5)
//                //                .onChange(of: episode.seen) { _, newValue in
//                //                    vm.updateEpisodeSeen(newValue, episode: episode)
//                //                }
//            }
            
            
//            if let episodeIndex = vm.episodes.firstIndex(where: { $0.id == episode.id }) {
//                Toggle(isOn: $vm.episodes[episodeIndex].seen) {
//                    
//                }
//                .toggleStyle(.checkmark)
//                .padding(.trailing, 5)
////                .onChange(of: episode.seen) {
////                    if let index = vm.episodes.firstIndex(of: episode) {
////                        vm.episodes[index].seen.toggle()
////                    }
////                }
//            }
            
//            if let episodeIndex = vm.episodes.firstIndex(where: { $0.id == episode.id }) {
            Toggle(isOn: $isChecked) {
                    
                }
                .toggleStyle(.checkmark)
                .padding(.trailing, 5)
//                .onChange(of: episode.seen, initial: episode.seen, { oldValue, newValue in
//                    vm.toggleSeen(episode: episode)
//                })
                .onChange(of: isChecked) {
                    vm.toggleSeen(episode: episode)
                }
//            }
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


#Preview {
    EpisodeView.preview
}

