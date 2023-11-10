//
//  Movie.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import Foundation
struct Movie: Identifiable, Hashable {
    var title: String
    let id: UUID

    init(title: String) {
        self.title = title
        self.id = UUID()
    }

    static func examples() -> [Movie] {
        [
            Movie(title: "Modern Times"),
            Movie(title: "General"),
            Movie(title: "Imperium strike back"),
            Movie(title: "Star wars")

        ]
    }
}
