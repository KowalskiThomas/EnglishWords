//
//  ContentView.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 23/09/2024.
//

import SwiftUI

struct ContentView: View {
    var store: WordsStore
    var words: WordsManager
    var learningManager: LearningManager
    
    var body: some View {
        NavigationStack {
            LearningPage(store: store, manager: learningManager)
                .navigationTitle("Hello")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: {
                            SettingsPage(store: store)
                        }) {
                            Text("Settings")
                        }
                    }
                }
        }
    }
}

#Preview {
    let store = WordsStore()
    ContentView(
        store: store,
        words: WordsManager.instance(wordsStore: store),
        learningManager: LearningManager(store: store)
    )
}
