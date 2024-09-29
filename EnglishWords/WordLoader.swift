//
//  WordLoader.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 23/09/2024.
//

import Foundation
import SwiftUI

class WordsManager {
    static private var _instance: WordsManager = WordsManager();
    
    private var loadedWords: [String] = []
    
    static public func instance() -> WordsManager {
        return WordsManager._instance
    }
    
    public func loadFile() -> [String] {
        if !loadedWords.isEmpty {
            return loadedWords
        }
        
        var fileContent: String = ""
        if let fileURL = Bundle.main.url(forResource: "words_shuffled", withExtension: "txt") {
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
        
        let lines = fileContent.split(separator: "\n").map({ s in String(s) })
        let nonEmptyLines = lines.filter({ s in s != ""})
        
        self.loadedWords = nonEmptyLines
        return self.loadedWords
    }
}
