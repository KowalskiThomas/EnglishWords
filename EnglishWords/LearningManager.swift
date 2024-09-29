//
//  LearningManager.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 29/09/2024.
//

import Foundation
import SwiftUI

class LearningManager : ObservableObject {
    let learningPoolSize = 10
    let useRoundRobinForLearning = false
    
    @Published var currentIndex = 0
    @Published var currentWord: String
    @Published var currentWordTranslation: String
    
    var wordsManager = WordsManager.instance()
    var allWords: [String]
    var wordsBeingLearnt: [String]
    var wordsAlreadyLearnt: [String]
    var wordsLeftToLearn: [String]
    
    init() {
        let currentIndex = 0
        self.currentIndex = currentIndex
        self.currentWord = ""
        self.currentWordTranslation = ""
        self.allWords = wordsManager.loadFile()
        
        // TODO: Persist this
        self.wordsBeingLearnt = [String](allWords[...learningPoolSize])
        self.wordsLeftToLearn = [String](allWords[learningPoolSize...])
        self.wordsAlreadyLearnt = []

        self.updateWordForIndex()
    }
    
    private func updateWordForIndex() {
        self.currentWord = wordsBeingLearnt[currentIndex]
        self.currentWordTranslation = "trans \(self.currentWord)"
    }
    
    func nextWord() {
        if useRoundRobinForLearning {
            currentIndex = (currentIndex + 1) % self.wordsBeingLearnt.count
        } else {
            let newCurrentIndex = Int.random(in: 0...self.wordsBeingLearnt.count - 1)
            currentIndex = newCurrentIndex != currentIndex ? newCurrentIndex : (newCurrentIndex + 1) % self.wordsBeingLearnt.count
        }

        self.updateWordForIndex()
        print("Current index is \(currentIndex) and word is '\(currentWord)'")
    }
    
    private func markCurrentWordAsLearnt() {
        wordsBeingLearnt.remove(at: currentIndex)
        wordsAlreadyLearnt.append(currentWord)
        print("Marked '\(currentWord)' as leant")
    }
    
    private func insertNewWord() {
        let newWord = wordsLeftToLearn[0]
        wordsBeingLearnt.append(newWord)
        wordsLeftToLearn.remove(at: 0)
        print("Inserting word to learn: '\(newWord)'")
    }
    
    func markCurrentWordAsLearntAndInsertNewOne() {
        markCurrentWordAsLearnt()
        insertNewWord()
    }
}
