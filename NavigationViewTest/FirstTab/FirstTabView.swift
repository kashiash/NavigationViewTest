//
//  FirstTabView.swift
//  NavigationViewTest
//
//  Created by Jacek Kosinski U on 08/11/2023.
//

import SwiftUI

struct FirstTabView: View {
    @State private var showSettings = false
    @State private var path = NavigationPath()
    var body: some View {
        VStack {
            NavigationStack (path: $path){
                List {
                    Text("Root View")
                    NavigationLink("Goto detail view A",value: "Show AAA")

                    NavigationLink("Goto detail view B",value: "Show BBB")

                    NavigationLink("Goto detail view 1",value: 1)


                    Button("Show settings") {
                        showSettings.toggle()
                    }

                    Button {
                        path.append("GGG")
                    } label: {
                        Text("Go to favorites")
                    }



                    Section ("Old"){
                        NavigationLink ("Old link with destination ") {
                            Text("Old navigation link")
                            NavigationLink("Go to 2", value: 2)
                        }
                    }
                }
                .navigationDestination(for: String.self) { textValue in
                    //Text("detail with value: \(textValue)")
                    DetailView(text: textValue, path: $path)
                }
                .navigationDestination(for: Int.self) { intValue in
                    Text("detail with INT value: \(intValue)")
                }
                .navigationDestination(isPresented: $showSettings) {
                    Text("Settings")
                }
            }

            VStack {
                Text("Path")
                Text("Number of detail views on stack: \(path.count)")
                Button {
                    path.removeLast()
                } label: {
                    Text("go back one view")
                }

                Button {
                    path = NavigationPath()
                } label: {
                    Text("go to root view")
                } 
           }
        }
    }
}

#Preview {
    FirstTabView()
}
