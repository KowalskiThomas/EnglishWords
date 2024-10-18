import SwiftUI
import Foundation

struct PersistedData: Codable {
    let CustomWords: [Word]
    let KnownWords: [String]
    
    let UseRandomOrder: Bool
    let WordsInPool: Int
}

class WordsStore: ObservableObject {
    @Published var customWords: [Word] = []
    // TODO: Make it so Known Words have their date/time
    @Published private(set) var knownWords: [String] = []
    
    @Published var useRandomOrder: Bool = false
    @Published var numberOfWordsInPool: Int = 10
    
    var knownWordsSet = Set<String>()
    
    public static func fromData(customWords: [Word], knownWords: [String]) -> WordsStore {
        let result = WordsStore()
        result.customWords = customWords
        
        result.knownWordsSet = Set(knownWords)
        result.knownWords = knownWords
        return result
    }

    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("words.data")
    }

    func load() async throws {
        print("Trying to load data...")
        let task = Task<PersistedData?, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                print("-> No data at the moment!")
                return nil
            }
            return try JSONDecoder().decode(PersistedData.self, from: data)
        }
        do {
            let data = try await task.value
            if let data = data {
                DispatchQueue.main.async {
                    self.customWords = data.CustomWords
                    self.knownWordsSet = Set(data.KnownWords)
                    self.knownWords = data.KnownWords
                    self.numberOfWordsInPool = data.WordsInPool
                    self.useRandomOrder = data.UseRandomOrder
                    print("We have \(self.customWords.count) custom words and \(self.knownWords.count) known words")
                }
            }
        } catch {
            print("Could not load data from the file...")
        }
    }

    func save(data: PersistedData) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(data)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
        print("Save finished...")
    }
    
    func saveNow() async throws {
        let persistedData = PersistedData(
            CustomWords: customWords,
            KnownWords: knownWords,
            UseRandomOrder: useRandomOrder,
            WordsInPool: numberOfWordsInPool
        )
        try await self.save(data: persistedData)
    }
    
    func startSaveNow() {
        Task { @MainActor in
            try await self.saveNow()
        }
    }
    
    public func removeCustomWords(at offsets: IndexSet) {
        customWords.remove(atOffsets: offsets)
    }
    
    func addKnownWord(_ word: String) {
        if self.knownWordsSet.contains(word) {
            return
        }

        self.knownWordsSet.insert(word)
        self.knownWords.append(word)
    }
}

func SampleWordsStore() -> WordsStore {
    return WordsStore.fromData(customWords: SampleCustomWords(), knownWords: ["car", "bat", "tree"])
}
