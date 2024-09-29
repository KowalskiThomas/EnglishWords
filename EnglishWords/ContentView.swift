//
//  ContentView.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 23/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State var navigationTitleForHomeScreen = "Hello"
    
    var body: some View {
        NavigationStack {
            LearningPage()
                .navigationTitle($navigationTitleForHomeScreen)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: {
                            SettingsPage()
                        }) {
                            Text("Settings")
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
