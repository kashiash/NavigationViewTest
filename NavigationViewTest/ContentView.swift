//
//  ContentView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 08/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            FirstTabView()
                .tabItem {
                    Label("First", systemImage: "square.grid.3x3.middleleft.filled")
                }
            SecondViewTab()
                .tabItem {
                    Label("Second", systemImage: "book")
                }

            ThirdTabView()
                .tabItem {
                    Label("Third", systemImage: "music.quarternote.3")
                }
        }
    }
}

#Preview {
    ContentView()
}
