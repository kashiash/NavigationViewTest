//
//  NavigationStateManager.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 10/11/2023.
//

import Foundation

enum SelectionState:Hashable {
    case movie(Movie)
    case song(Song)
    case book(Book)
    case settings
}

class NavigationStateManager: ObservableObject {
    @Published var selectionPath = [SelectionState]()

    func goToRoot() {
        selectionPath = []
    }
    func goToSettings() {
        selectionPath = [SelectionState.settings]
    }
}
