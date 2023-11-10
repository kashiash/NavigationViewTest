//
//  SettingsView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 09/11/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text("This is settings view")
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
