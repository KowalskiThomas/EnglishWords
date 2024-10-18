//
//  SettingsPage.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 29/09/2024.
//

import SwiftUI


struct StatisticsItem: View {
    var name: String
    var value: String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(value)
                .fontDesign(.monospaced)
        }
    }
}

extension StatisticsItem {
    init(_ name: String, _ value: Int) {
        self.init(name, "\(value)")
    }
    
    init(_ name: String, _ value: String) {
        self.name = name
        self.value = value
    }
}

struct SettingsPage: View {
    @StateObject var store: WordsStore
    
    var wordsInApp: Int {
        return WordsManager.instance().allWords.count
    }
    
    var body: some View {
        Form {
            Section("Learning") {
                Stepper(value: $store.numberOfWordsInPool, in: 1...1000000) {
                    Text("Words in pool: \(store.numberOfWordsInPool)")
                }
                Toggle(isOn: $store.useRandomOrder) {
                    Text("Randomly pick next word")
                }
            }
            Section("User data") {
                NavigationLink(destination: {
                    List {
                        ForEach(store.knownWords, id: \.self) { w in
                            Text(w)
                        }
                    }
                        .navigationTitle("Words learnt")
                }) {
                    Text("See all words learnt so far")
                } 
                NavigationLink(destination: {
                    CustomWordsView(store: store)
                }) {
                    Text("Manage custom words")
                }
            }
            Section("Statistics") {
                StatisticsItem("Words in app", wordsInApp)
                StatisticsItem("Words learnt", store.knownWords.count)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsPage(store: SampleWordsStore())
    }
}
