//
//  Book.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 08/11/2023.
//

import Foundation

struct Book: Identifiable,Hashable {
    let id: UUID
    var title: String

    init(title: String) {
        self.id = UUID()
        self.title = title
    }
    static func examples() -> [Book] {
        [
            Book(title: "Pan Tadeusz"),
            Book(title: "Solaris"),
            Book(title: "Eden"),
            Book(title: "Cesarz"),
            Book(title: "Heban"),
        ]
    }
}
