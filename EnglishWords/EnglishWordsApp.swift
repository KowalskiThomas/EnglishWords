//
//  EnglishWordsApp.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 23/09/2024.
//

import SwiftUI

@main
struct EnglishWordsApp: App {
    private var store: WordsStore;
    private var learningManager: LearningManager
    private var wordsManager: WordsManager

    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView(store: store, words: wordsManager, learningManager: learningManager)
                .task {
                    do {
                        try await store.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        print("Saving now")
                        Task {
                            do {
                                try await store.saveNow()
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                }
        }
    }
    
    init() {
        self.store = WordsStore()
        self.wordsManager = WordsManager.instance(wordsStore: store)
        self.learningManager = LearningManager(store: store)
    }
}

