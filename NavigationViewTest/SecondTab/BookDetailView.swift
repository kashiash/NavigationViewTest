//
//  BookDetailView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 08/11/2023.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    var body: some View {
        VStack {
            Text(book.title)
            Divider()
            ForEach(1...4, id: \.self) { id in
                NavigationLink("suggestion \(id)", value: Book(title: "suggestion no \(id)"))
            }
        }
        .navigationTitle("Book detail view")
    }
}

#Preview {
    BookDetailView(book: Book(title: "Jebać PiS"))
}
