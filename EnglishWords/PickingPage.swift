//
//  PickingPage.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 29/09/2024.
//

import SwiftUI

struct PickingPage: View {
    var words: [String] = ExampleWords()

    var body: some View {
        WordSelectionList(words: words)
        .navigationTitle("New words")
    }
}

#Preview {
    NavigationStack {
        PickingPage(words: ExampleWords())
    }
}
