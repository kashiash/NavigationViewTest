//
//  MovieDetailView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text(movie.title)
            Divider()
            ForEach(1...4, id: \.self) { id in
                NavigationLink("suggestion \(id)", value: SelectionState.movie(Movie(title: "suggestion no \(id)")))
            }
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie.examples().randomElement()!)
}
