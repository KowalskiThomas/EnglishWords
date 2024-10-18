//
//  LearningManager.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 29/09/2024.
//

import Foundation
import SwiftUI
import Combine

class LearningManager : ObservableObject {
    let useRoundRobinForLearning = false
    
    @Published var currentIndex = 0
    @Published var currentWord: String
    @Published var currentWordTranslation: String
    
    @ObservedObject var store: WordsStore
    var wordsManager = WordsManager.instance()

    var wordsBeingLearnt: [Word]
    var wordsLeftToLearn: [Word]
    
    private var cancellableAllWords: AnyCancellable?
    private var cancellableKnownWords: AnyCancellable?
    private var cancellableNumberOfWords: AnyCancellable?
    
    init(store: WordsStore) {
        self.store = store

        self.currentIndex = 0
        self.currentWord = ""
        self.currentWordTranslation = ""

        self.wordsBeingLearnt = []
        self.wordsLeftToLearn = []
        
        // Every time All Words is updated (meaning at the app load, or when the
        // user adds a new custom word, we need to update our words to learn).
        cancellableAllWords = self.wordsManager.$allWords.sink { allWords in
            print("--- Updating after allWords")

            if allWords.isEmpty {
                return
            }
            
            let wordCount = min(self.store.numberOfWordsInPool, allWords.count)
            
            var i = 0
            self.wordsBeingLearnt = []
            while self.wordsBeingLearnt.count < wordCount {
                let word = allWords[i]
                if self.store.knownWordsSet.contains(word.english) {
                    i += 1
                    continue
                }
                
                self.wordsBeingLearnt.append(word)
                i += 1
            }
            
            self.wordsLeftToLearn = [Word](allWords[i...])
            self.nextWord()
        }
        
        cancellableKnownWords = self.store.$knownWords.sink { knownWords in
            print("--- Updating after knownWords")

            if knownWords.isEmpty {
                return
            }
            
            let allWords = self.wordsManager.allWords
            let wordCount = min(self.store.numberOfWordsInPool, allWords.count)
            
            var i = 0
            self.wordsBeingLearnt = []
            while self.wordsBeingLearnt.count < wordCount {
                let word = allWords[i]
                if self.store.knownWordsSet.contains(word.english) {
                    i += 1
                    continue
                }
                
                self.wordsBeingLearnt.append(word)
                i += 1
            }
            
            self.wordsLeftToLearn = [Word](allWords[i...])
            self.nextWord()
        }
        
        cancellableNumberOfWords = store.$numberOfWordsInPool.sink(receiveValue: { numberOfWords in
            print("--- Updating after numberOfWordsInPool")
            if numberOfWords == self.wordsBeingLearnt.count {
                return
            }
            
            if numberOfWords < self.wordsBeingLearnt.count {
                print("Trimming wordsBeingLearnt to \(numberOfWords) words")
                self.wordsBeingLearnt = [Word](self.wordsBeingLearnt[0...numberOfWords])
                return
            }
            
            // We are sure we need more words
            for _ in self.wordsBeingLearnt.count + 1...numberOfWords {
                self.insertNewWord()
            }
        })
        
        self.nextWord()
    }
    
    private func updateWordForIndex() {
        if wordsBeingLearnt.isEmpty {
            return 
        }
        
        // print("Current index: \(currentIndex), \(wordsBeingLearnt.count) words being learnt: \(wordsBeingLearnt)")
        let currentWord = wordsBeingLearnt[currentIndex]
        self.currentWord = currentWord.english
        self.currentWordTranslation = currentWord.french
        print("Current index is \(currentIndex) (/ \(wordsBeingLearnt.count)) and word is '\(currentWord)'")
    }
    
    func nextWord() {
        if self.wordsBeingLearnt.count == 0 {
            return
        }
        
        if useRoundRobinForLearning {
            currentIndex = (currentIndex + 1) % self.wordsBeingLearnt.count
        } else {
            let newCurrentIndex = Int.random(in: 0...self.wordsBeingLearnt.count - 1)
            currentIndex = newCurrentIndex != currentIndex ? newCurrentIndex : (newCurrentIndex + 1) % self.wordsBeingLearnt.count
        }

        self.updateWordForIndex()
    }
    
    private func markCurrentWordAsLearnt() {
        let newKnownWord = currentWord
        wordsBeingLearnt.remove(at: currentIndex)
        store.addKnownWord(newKnownWord)
        print("Marked '\(newKnownWord)' as learnt")
    }
    
    private func insertNewWord() {
        if wordsLeftToLearn.isEmpty {
            return
        }
        
        let newWord = wordsLeftToLearn[0]
        wordsBeingLearnt.append(newWord)
        wordsLeftToLearn.remove(at: 0)
        print("Inserting word to learn: '\(newWord)'")
    }
    
    func markCurrentWordAsLearntAndInsertNewOne() {
        print("--- markCurrentWordAsLearntAndInsertNewOne")
        markCurrentWordAsLearnt()
        insertNewWord()
    }
}
