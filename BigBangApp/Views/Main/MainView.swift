//
//  ContentView.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//


//TODO:
//    Acabar el completar el visto en toda una season
//    Arreglar el tap en el checkbox para no tener que darle dos veces para cambiar de estado y a la estrella del detalle
//
//  ✅  Añadir botón de favoritos en la navigation bar que filtre los episodios por favoritos
//    Crear pantalla de detalle del episodio en el que pueda guardar: favorito, valoración de 1 a 5 estrellas y un texto libre.
//Extra: Modificar la navegación para que el pulsar en el checkbox no detecte también el tap de la celda
//Extra: Modificar las secciones para poder pulsar en ellas y que se oculten los episodios
//Extra: Modificar las secciones de las seasons para usar también las portadas/imágenes.
//Extra: Crear una vista que muestre la imagen principal de la serie con un gauge del porcentaje que llevas visto de la serie.
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
                            Toggle(isOn: Binding(
                                get: { self.vm.seasonCheckedState[season] ?? false },
                                set: { self.vm.seasonCheckedState[season] = $0 }
                            )) {
                                Text("Season watched")
                            }
                            .toggleStyle(.checkmark)
                            .padding(.trailing, 5)
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
