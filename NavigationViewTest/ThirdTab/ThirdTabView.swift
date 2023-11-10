//
//  ThirdTabView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import SwiftUI



struct ThirdTabView: View {
    @StateObject var model = ModelDataManager()
    @StateObject var navigationStateManager = NavigationStateManager()
    var body: some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
            RootView(model: model)
                .navigationDestination(for: SelectionState.self) { state in
                    Group {
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
        .environmentObject(model)
        .environmentObject(navigationStateManager)
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ThirdTabView()
}
