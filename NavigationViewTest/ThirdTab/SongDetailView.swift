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
    var body: some View {
        VStack{
            Text("Song detail")
            Text(song.title)
            Text(song.artist)
            Text("\(song.year)")
            Divider()
            VStack(alignment: .leading) {
                Text("Inne piosenki do polubienia")

                ForEach(model.songs) { song in
                    NavigationLink(value: song) {
                        Label(song.title,systemImage: "music.note")
                    }
                }
            }
        }
    }
}

        #Preview {
            SongDetailView(song: Song.examples().randomElement()!)
                .environmentObject(ModelDataManager())
        }
