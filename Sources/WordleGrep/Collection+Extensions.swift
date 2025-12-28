//
//  File.swift
//  WordleGrep
//
//  Created by Jesus Saenz on 21/12/25.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
      indices.contains(index) ? self[index] : nil
    }
}
