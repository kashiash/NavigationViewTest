//
//  Book.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import Foundation

struct  Song : Identifiable,Hashable {
    var title: String
    var artist: String
    var year:Int
    let id: UUID

    init(title: String, artist: String, year: Int) {
        self.title = title
        self.artist = artist
        self.year = year
        self.id = UUID()
    }

    static func examples() -> [Song] {
        [
            Song(title: "La Isla Bonita", artist: "Madonna", year: 1986),
            Song(title: "Billie Jean", artist: "Michael Jackson", year: 1982),
            Song(title: "Bohemian Rhapsody", artist: "Queen", year: 1975),
            Song(title: "Like a Rolling Stone", artist: "Bob Dylan", year: 1965),
            Song(title: "Imagine", artist: "John Lennon", year: 1971),
            Song(title: "Purple Haze", artist: "Jimi Hendrix", year: 1967),
            Song(title: "Smells Like Teen Spirit", artist: "Nirvana", year: 1991),
            Song(title: "Hey Jude", artist: "The Beatles", year: 1968),
            Song(title: "I Want to Hold Your Hand", artist: "The Beatles", year: 1963),
            Song(title: "Hotel California", artist: "Eagles", year: 1977)
        ]
    }
}
