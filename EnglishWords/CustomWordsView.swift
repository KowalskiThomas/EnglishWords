//
//  CustomWordsView.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 29/09/2024.
//

import SwiftUI

func SampleCustomWords() -> [Word] {
    return [
        Word(en: "hello", fr: "salut"),
        Word(en: "car", fr: "voiture"),
    ]
}

struct CustomWordsView: View {
    @State var customWord: String = ""
    @State var customWordTranslation: String = ""
    
    @StateObject var wordManager = WordsManager.instance()
    @StateObject var store: WordsStore
    
    var body: some View {
        VStack {
            Form {
                Section("Add word") {
                    TextField("New word in English", text: $customWord)
                        .onSubmit(addNewWord)
                        .keyboardType(.alphabet)
                    TextField("New word in French", text: $customWordTranslation)
                        .onSubmit(addNewWord)
                }
                
                Section("Existing words") {
                    List {
                        ForEach(store.customWords) { w in
                            HStack {
                                Text(w.english)
                                Spacer()
                                Text(w.french)
                            }
                        }
                        .onDelete(perform: { indices in
                            store.removeCustomWords(at: indices)
                            store.startSaveNow()
                        })
                    }
                }
            }
        }
            .navigationTitle("Custom words")
    }
    
    func addNewWord() {
        if customWord.isEmpty || customWordTranslation.isEmpty {
            return
        }
        
        store.customWords.append(Word(en: customWord, fr: customWordTranslation))
        store.startSaveNow()
        
        customWord = ""
        customWordTranslation = ""
    }
}

#Preview {
    NavigationStack {
        CustomWordsView(store: WordsStore())
    }
}
