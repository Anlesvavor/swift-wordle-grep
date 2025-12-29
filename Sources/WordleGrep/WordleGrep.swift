// The Swift Programming Language
// https://docs.swift.org/swift-book

import Algorithms

public enum WordleChar {
    case Green(char: Character)
    case Yellow(char: Character)
    case Black(char: Character)
    case Unknown
}

extension WordleChar: Equatable {}

extension WordleChar: Sendable {}

extension WordleChar {
    static let modifiers: Set<Character> = ["!", "?"]

    init?(from string: String) {
        precondition((1...2).contains(string.count))
        let firstIndex = string.startIndex
        let firstChar = string[firstIndex]
        let nextChar = string[safe: string.index(after: firstIndex)]
        guard !WordleChar.modifiers.contains(firstChar) else { return nil }
        self.init(from: firstChar, modifier: nextChar)
    }

    init?(from char: Character) {
        guard !WordleChar.modifiers.contains(char) else { return nil }
        self = switch (char) {
        case ("_"): WordleChar.Unknown
        case (_): WordleChar.Green(char: char)
        }
    }

    init?(from char: Character, modifier: Character?) {
        guard !WordleChar.modifiers.contains(char) else { return nil }
        self = switch (char, modifier) {
        case ("_", nil): WordleChar.Unknown
        case ("_", _): WordleChar.Unknown
        case (_, "?"): WordleChar.Yellow(char: char)
        case (_, "!"): WordleChar.Black(char: char)
        case (_, _): WordleChar.Green(char: char)
        }
    }

}

public typealias WordleWord = [WordleChar]

extension WordleWord {
    public init(from string: String) {
        var result: [WordleChar] = []
        result = string.adjacentPairs().compactMap { (char, nextChar) in
            WordleChar(from: char, modifier: nextChar)
        }
        if let lastChar = string.last, let lastWordleChar = WordleChar(from: lastChar, modifier: nil) {
            result.append(lastWordleChar)
        }
        self = result
    }
}

extension String {
    public func matches(wordle pattern: WordleWord) -> Bool {
        guard self.count == pattern.count else { return false }
        let charSet = Set(self)
        return zip(self, pattern).allSatisfy { (element, wordleChar) in
            switch wordleChar {
            case .Green(char: let char): char == element
            case .Yellow(char: let char): char != element && charSet.contains(char)
            case .Black(char: let char): !charSet.contains(char)
            case .Unknown: true
            }
        }
    }
}

