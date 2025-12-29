import Testing
@testable import WordleGrep

@Test(
    "init WordleChar from String",
    arguments: [
        ("x", WordleChar.Green(char: "x")),
        ("x!", WordleChar.Black(char: "x")),
        ("x?", WordleChar.Yellow(char: "x")),
        ("_", WordleChar.Unknown)
    ]
)
func initFrom(string: String, expected: WordleChar) async throws {
    #expect(WordleChar.init(from: string) == expected)
}

@Test(
    "init [WordleChar] from String",
    arguments: [
        ("xy", [WordleChar.Green(char: "x"), WordleChar.Green(char: "y")]),
        ("x!y!", [WordleChar.Black(char: "x"), WordleChar.Black(char: "y")]),
        ("x?y?", [WordleChar.Yellow(char: "x"), WordleChar.Yellow(char: "y")]),
        ("x?y!", [WordleChar.Yellow(char: "x"), WordleChar.Black(char: "y")]),
        ("x!y?", [WordleChar.Black(char: "x"), WordleChar.Yellow(char: "y")]),
        ("_x", [WordleChar.Unknown, WordleChar.Green(char: "x")]),
        ("_x!", [WordleChar.Unknown, WordleChar.Black(char: "x")]),
        ("_x?", [WordleChar.Unknown, WordleChar.Yellow(char: "x")]),
        ("x?_", [WordleChar.Yellow(char: "x"), WordleChar.Unknown]),
        ("x!_", [WordleChar.Black(char: "x"), WordleChar.Unknown])
    ]
)
func initFrom(string: String, expected: [WordleChar]) async throws {
    #expect([WordleChar].init(from: string) == expected)
}


@Test(
    "'matches(wordle: WordleWord)' function",
    arguments: [
        ("A?B?C?D?E?", "EDBCA", "All Yellows"),
        ("EDBCA", "EDBCA", "All Green"),
        ("_____", "EDBCA", "All Unknown"),
        ("Z!Y!X!W!V!", "EDBCA", "All Black"),
        ("E?HZ!C!_", "WHOLE", "Mixed"),
    ]
)
func matches(wordle stringPattern: String, word: String, comment: Comment) async throws {
    #expect(word.matches(wordle: WordleWord(from: stringPattern)), comment)
}


@Test(
    "filter(wordle pattern) -> any Sequence<String>",
    arguments: [
        (["aaa", "aab", "aba", "baa", "abb", "bba", "bbb"], WordleWord.init(from: "a__"), ["aaa", "aab", "aba", "abb"]),
        (["aaa", "aab", "aba", "baa", "abb", "bba", "bbb"], WordleWord.init(from: "__b"), ["aab", "abb", "bbb"]),
        (["aaa", "aab", "aba", "baa", "abb", "bba", "bbb"], WordleWord.init(from: "__b?"), ["aba", "baa", "bba"]),
        (["aaa", "aab", "aba", "baa", "abb", "bba", "bbb"], WordleWord.init(from: "__b!"), ["aaa"]),
        (["aaa", "aab", "aba", "baa", "abb", "bba", "bbb"], WordleWord.init(from: "_a!b?"), []),
        (["aaa", "aab", "aba", "baa", "abb", "bba", "bbb"], WordleWord.init(from: "b!a!b?"), [])
    ]
)
func filter(collection: [String], wordle pattern: WordleWord, result: [String]) {
    #expect(collection.filter(wordle: pattern).elementsEqual(result))
}
