//
//  WelcomePage.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 29/09/2024.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack {
            NavigationLink(destination: {
                LearningPage()
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
    }
}

#Preview {
    WelcomePage()
}
