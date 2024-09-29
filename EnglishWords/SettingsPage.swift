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
    @State var useRandomOrder: Bool = false
    @State var fieldContents: String = ""
    @State var countWordsInPool = 10
    
    var wordsInApp: Int {
        return WordsManager.instance().loadFile().count
    }
    
    var body: some View {
        Form {
            Section("Learning") {
                Stepper(value: $countWordsInPool) {
                    Text("Words in pool: \(countWordsInPool)")
                }
                Toggle(isOn: $useRandomOrder) {
                    Text("Randomly pick next word")
                }
            }
            Section("User data") {
                NavigationLink(destination: {
                    Text("TODO")
                        .navigationTitle("Words learnt")
                }) {
                    Text("See all words learnt so far")
                }
            }
            Section("Statistics") {
                StatisticsItem("Words in app", wordsInApp)
                StatisticsItem("Words learnt", 1234)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsPage()
    }
}
