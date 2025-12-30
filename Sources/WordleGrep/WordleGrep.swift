// The Swift Programming Language
// https://docs.swift.org/swift-book

import Algorithms

public enum WordleChar {
    case Green(char: Character)
    case Yellow(char: Character)
    case Black(char: Character)
    case Unknown

    // Alternate "spellings"
    static let yellowModifiers = Set<Character>(["?", "*"])
    static let blackModifiers = Set<Character>(["!", "^"])
    static let modifiers = yellowModifiers.union(blackModifiers)
}

extension WordleChar: Equatable {}

extension WordleChar: Sendable {}

extension WordleChar {

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
        case (_, nil): WordleChar.Green(char: char)
            // TODO: Annonying check
        case (_, let m) where m != nil && WordleChar.yellowModifiers.contains(m!): WordleChar.Yellow(char: char)
        case (_, let m) where m != nil && WordleChar.blackModifiers.contains(m!): WordleChar.Black(char: char)
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


    public func matches(wordle patterns: [WordleWord]) -> Bool {
        return patterns.allSatisfy({ self.matches(wordle: $0) })
        // TODO: More efficient?
//        enum MatchesErrors: Error { case InvariantError }
//        let charset = Set(self)
//        enum keys { case Green, Yellow, Black, Other }
//        let groupedWordleCharsWithIndex = patterns
//            .flatMap({ $0.indexed() })
//            .joined()
//            .grouped { (position, wordleChar) in
//            switch wordleChar {
//            case .Green(char: _): keys.Green
//            case .Black(char: _): keys.Black
//            case .Yellow(char: _): keys.Yellow
//            default: keys.Other
//            }
//        }
//        let greenCharsWithIndex = groupedWordleCharsWithIndex[keys.Green]
//        if greenCharsWithIndex != nil {
//            let greenCharsPositions = Set(arrayLiteral: greenCharsWithIndex?.map { $0.index })
//            guard greenCharsPositions.count == greenCharsWithIndex?.count else {
//                // Conflicting green chars, different chars occupying the same position!!!
//                return false
//            }
//            let stringFoundInPattern = String(greenCharsWithIndex?.compactMap {
//                guard case let WordleChar.Green(char: char) = $0.element else {
//                    return nil
//                }
//                return char
//            } ?? [])
//            if stringFoundInPattern == self {
//                return true
//            }
//        }
//        if let b = groupedWordleCharsWithIndex[keys.Black] {
//            let blackChars = Set<Character>(b.compactMap({ (_, element) in
//                guard case let WordleChar.Black(char: char) = element else {
//                    return nil
//                }
//                return char
//            }))
//            guard charset.intersection(blackChars).isEmpty else {
//                return false
//            }
//        }
//        let yellowChars: any Sequence<IndexedCollection<[WordleChar]>.Element> = groupedWordleCharsWithIndex[keys.Yellow]?
//            .compactMap { ix in
//                guard case WordleChar.Yellow = ix.element else {
//                    return nil
//                }
//                return ix
//            } ?? []
//        yellowChars.allSatisfy { (position, element) in
//            guard let case WordleChar.Yellow(char: char) = element else {
//                return false
//            }
//            return self[position] != char && charset.contains(char)
//        }
//
    }

}

