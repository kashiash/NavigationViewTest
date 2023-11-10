//
//  RootView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import SwiftUI

struct RootView: View {
    @StateObject var model = ModelDataManager()
    var body: some View {
        List {
            Section("Books") {
                ForEach(model.books) {book in
                    NavigationLink(book.title, value: SelectionState.book(book))
                }
            }
            Section("Songs") {
                ForEach(model.songs) {song in
                    NavigationLink(song.title, value: SelectionState.song(song))
                }
            }
            Section("Movies") {
                ForEach(model.movies) {movie in
                    NavigationLink(movie.title, value: SelectionState.movie(movie))
                }
            }
            NavigationLink("Settings", value: SelectionState.settings)
        }
        .navigationTitle("Cacka")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RootView()
    }
}
