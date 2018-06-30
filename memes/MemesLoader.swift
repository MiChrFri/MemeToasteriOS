//
//  MemesLoader.swift
//  memes
//
//  Created by Michael Frick on 30/06/2018.
//  Copyright © 2018 Michael Frick. All rights reserved.
//

import Foundation

struct MemesLoader {
    private let userDefaults = UserDefaults.standard
    private let imageLoader = ImageLoader()
    
    internal func getAll() -> [Meme] {
        let memes = loadMemesData()
        return loadThumbnails(for: memes)
    }
    
    private func loadMemesData() -> [Meme]{
        var memes: [Meme] = []
        
        if let decoded = userDefaults.object(forKey: "memes") as? Data,
            let decodedMemes = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Meme] {
            memes = decodedMemes
        }
        
        return memes
    }
    
    private func loadThumbnails(for memes: [Meme]) -> [Meme] {
        return memes.map({ meme in
            if let memeId = meme.id {
                meme.thumbnail = imageLoader.get(byName: "thumbnail_\(memeId).png")
            }
            return meme
        })
    }
}
