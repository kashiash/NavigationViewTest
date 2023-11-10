//
//  ThirdTabView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import SwiftUI

enum SelectionState:Hashable {
    case movie(Movie)
    case song(Song)
    case book(Book)
    case settings
}

struct ThirdTabView: View {
    @StateObject var model = ModelDataManager()
    var body: some View {
        NavigationStack {
            RootView(model: model)
                .navigationDestination(for: SelectionState.self) { state in
                    switch state {
                    case .song(let song):
                        SongDetailView(song: song)
                    case .movie(let movie):
                        MovieDetailView(movie: movie)
                    case .book(let book):
                        BookDetailView(book: book)
                    case .settings:
                        SettingsView()
                    }

                }

        }
    }
}

#Preview {
    ThirdTabView()
}
