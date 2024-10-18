//
//  WordLoader.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 23/09/2024.
//

import Foundation
import SwiftUI
import Combine

struct Word: Identifiable, Codable, Hashable {
    var id: String {
        return english
    }

    let english: String
    let french: String
    
    init(en english: String, fr french: String) {
        self.english = english
        self.french = french
    }
}

class WordsManager: ObservableObject {
    static private var _instance: WordsManager? = nil
    
    @Published var loadedWords: [Word] = []
    @Published var customWords: [Word] = []
    @Published var allWords: [Word] = []

    private var store: WordsStore
    private var cancellable: AnyCancellable?
        
    static public func instance() -> WordsManager {
        guard let instance = _instance else {
            print("Trying to get WordsManager instance without initialising it")
            exit(1)
        }
        
        return instance
    }
    
    static public func instance(wordsStore: WordsStore) -> WordsManager {
        _instance = WordsManager(store: wordsStore)
        return _instance.unsafelyUnwrapped
    }
    
    private init(store: WordsStore) {
        self.store = store
        
        cancellable = store.$customWords.sink { customWordsFromStore in
            let newAllWords = self.mergeWordLists(customWordsFromStore, self.loadedWords)
            DispatchQueue.main.async {
                self.customWords = customWordsFromStore
                self.allWords = newAllWords
            }
        }
        loadFile()
    }
   
    private func parseCsv(_ fileContent: String) -> [Word] {
        let lines = fileContent.split(separator: "\n").map({ s in String(s) })
        let nonEmptyLines = lines.filter({ s in s != ""})
        
        var words: [Word] = []
        for line in nonEmptyLines {
            let items = line.split(separator: ";")
            let english = String(items[0])
            
            let french = String(items[1])
            let frenchSplit = french.split(separator: ",")
            let frenchTranslation = frenchSplit.joined(separator: ", ")
            
            words.append(Word(en: english, fr: frenchTranslation))
        }
        
        return words
    }
    
    public func loadFile() {
        if !loadedWords.isEmpty {
            return
        }
        
        var fileContent: String = ""
        if let fileURL = Bundle.main.url(forResource: "words_shuffled_translated", withExtension: "txt") {
            do {
                // Load the content of the text file
                let content = try String(contentsOf: fileURL, encoding: .utf8)
                fileContent = content
            } catch {
                print("Error loading file: \(error)")
                fileContent = "Failed to load file."
            }
        } else {
            print("File not found")
            fileContent = "File not found."
        }
        
        self.loadedWords = parseCsv(fileContent)
        self.allWords = self.mergeWordLists(self.customWords, loadedWords)
    }
    
    func mergeWordLists(_ customWords: [Word], _ loadedWords: [Word]) -> [Word] {
        var result: [Word] = []
        var addedWords = Set<String>()
        
        for w in customWords {
            result.append(w)
            addedWords.insert(w.english)
        }

        for w in loadedWords {
            if addedWords.contains(w.english) {
                continue
            }
            
            result.append(w)
        }
        
        return result
    }
}
