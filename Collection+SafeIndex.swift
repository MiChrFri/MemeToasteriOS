//
//  Collection+SafeIndex.swift
//  memes
//
//  Created by Michael Frick on 14/05/2018.
//  Copyright © 2018 Michael Frick. All rights reserved.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
