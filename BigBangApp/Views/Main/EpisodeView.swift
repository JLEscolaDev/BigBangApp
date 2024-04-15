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


#Preview {
    let vm = BigBangVM(interactor: bigBangDataTest)
    return if let episode = vm.episodesBySeason.first?.value.first {
        EpisodeView(episode: episode).environmentObject(vm)
    }else {
        Text("Failure in the preview. Data missing")
    }
}

