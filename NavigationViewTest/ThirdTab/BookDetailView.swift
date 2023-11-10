//
//  BookDetailView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text(book.title)
            Divider()
            ForEach(1...4, id: \.self) { id in
                NavigationLink("suggestion \(id)", value: SelectionState.book(Book(title: "suggestion no \(id)")))
            }
        }
    }
}

#Preview {
    BookDetailView(book: Book(title: "Book"))
}
