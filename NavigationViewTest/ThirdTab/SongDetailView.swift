//
//  SongDetailView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import SwiftUI

struct SongDetailView: View {
    let song: Song
    var body: some View {
        VStack{
            Text("Song detail")
            Text(song.title)
            Text(song.artist)
            Text("\(song.year)")
        }
    }
}

#Preview {
    SongDetailView(song: Song.examples().randomElement()!)
}
