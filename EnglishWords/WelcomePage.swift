//
//  WelcomePage.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 29/09/2024.
//

import SwiftUI

struct WelcomePage: View {
    @ObservedObject var store: WordsStore
    
    var body: some View {
        /*
        VStack {
            NavigationLink(destination: {
                LearningPage(
                    store: store,
                    manager: LearningManager(store: store)
                )
            }) {
                Text("Learn now")
            }
            .buttonStyle(.borderedProminent)

            NavigationLink(destination: {
                PickingPage()
            }) {
                Text("Pick new words")
            }
            .buttonStyle(.borderedProminent)
        }
         */
        Text("NOT USED")
    }
}

#Preview {
    WelcomePage(store: SampleWordsStore())
}
