//
//  SecondViewTab.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 08/11/2023.
//

import SwiftUI

struct SecondViewTab: View {
    let books = Book.examples()
    @State private var path = NavigationPath() // [Book]()
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(books) { book in
                    NavigationLink(book.title,value:book)
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
        }
    }
}

#Preview {
    SecondViewTab()
}
