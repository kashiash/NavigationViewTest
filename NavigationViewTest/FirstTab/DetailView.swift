//
//  DetailView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 08/11/2023.
//

import SwiftUI

struct DetailView: View {
    let text: String
    @Binding var path: NavigationPath
    var body: some View {

        VStack {
            Image(systemName: "")
            Text("Detail showing")
            Text(text)
            Divider()
            Section("Links") {

                NavigationLink("Goto detail view 3",value: 3)

                NavigationLink("Goto detail view CCC",value: "CCC")
            }
        }
        .navigationTitle(text)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    path.removeLast()
                } label : {
                    Image(systemName: "chevron.left.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(text: "AAA BBB CCCC",path: .constant(NavigationPath()))
    }
}
