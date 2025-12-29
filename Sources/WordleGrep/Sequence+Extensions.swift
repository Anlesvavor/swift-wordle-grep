//
//  Sequence+Extensions.swift
//  WordleGrep
//
//  Created by Jesus Saenz on 27/12/25.
//

import Foundation

extension Sequence where Element == String {
    public func filter(wordle pattern: WordleWord) -> any Sequence<String> {
        return filter { element in element.matches(wordle: pattern) }
    }
}
