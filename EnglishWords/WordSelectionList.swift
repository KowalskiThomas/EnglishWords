//
//  WordSelectionList.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 23/09/2024.
//

import SwiftUI

func ExampleWords() -> [String] {
    return ["hello", "world", "car", "cow", "cat"]
}

struct WordSelectionList: View {
    var words: [String]
    
    var body: some View {
        List(words, id: \.self) { word in
            Text(word)
        }
    }
}

#Preview {
    let words = ExampleWords()
    WordSelectionList(words: words)
}
