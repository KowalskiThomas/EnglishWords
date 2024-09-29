//
//  LearningPage.swift
//  EnglishWords
//
//  Created by Thomas Kowalski on 29/09/2024.
//

import SwiftUI

struct ActionButton: View {
    var action: () -> ()
    var label: String
    
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Text(label)
        }
        .buttonStyle(.bordered)
    }
}

struct TranslationText: View {
    @Binding var showTranslation: Bool
    var translation: String
    
    var body: some View {
        if showTranslation {
            Text(translation)
                .font(.title2)
        } else {
            Text("Translation hidden")
                .italic()
                .font(.title2)
        }
    }
}

struct WordCard: View {
    @ObservedObject public var manager: LearningManager
    @State var notSure = false
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Text(manager.currentWord)
                    .font(.largeTitle)
                TranslationText(
                    showTranslation: $notSure,
                    translation: self.currentWordTranslation
                )
            }
            .transition(.slide)
            .padding()
            HStack {
                if !notSure {
                    ActionButton(action: {
                        manager.markCurrentWordAsLearntAndInsertNewOne()
                        manager.nextWord()
                        notSure = false
                    }, label: "I know it!")
                    
                    ActionButton(action: {
                        notSure = true
                    }, label: "I'm not sure...")
                } else {
                    ActionButton(action: {
                        manager.markCurrentWordAsLearntAndInsertNewOne()
                        manager.nextWord()
                        notSure = false
                    }, label: "Got it")
                    ActionButton(action: {
                        manager.nextWord()
                        notSure = false
                    }, label: "Show again")
                }
            }
        }
    }
    
    var currentWordTranslation: String {
        if !notSure {
            return "qsd"
        }
        
        return manager.currentWordTranslation
    }
}

struct LearningPage: View {
    @StateObject var manager = LearningManager()
    
    var body: some View {
        VStack {
            WordCard(manager: manager)
        }
        .navigationTitle("Learning")
    }
}

#Preview {
    LearningPage()
}
