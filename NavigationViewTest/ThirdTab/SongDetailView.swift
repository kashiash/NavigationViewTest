//
//  SongDetailView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import SwiftUI

struct SongDetailView: View {
    let song: Song
    @EnvironmentObject var model: ModelDataManager
    @EnvironmentObject var navigationState: NavigationStateManager
    var body: some View {
        VStack{
            Image(systemName: "music.mic.circle")
                .font(.largeTitle)
            Text("Song detail")
                .font(.title)
            Text(song.title)
            Text(song.artist)
            Text("\(song.year)")
            Divider()
            VStack(alignment: .leading) {
                Text("Inne piosenki do polubienia")
                    .font(.callout)
                
                ForEach(model.songs) { song in
                    //  NavigationLink(value: song) {
                    NavigationLink(value: SelectionState.song(song)) {
                        Label(song.title,systemImage: "music.note")
                    }
                }
            }
            Button("Go to root",systemImage: "gobackward") {
                navigationState.goToRoot()
            }
        }
        .navigationTitle("Dupa zbita")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    navigationState.goToSettings()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SongDetailView(song: Song.examples().randomElement()!)
            .environmentObject(ModelDataManager())
            .environmentObject(NavigationStateManager())
    }
}
