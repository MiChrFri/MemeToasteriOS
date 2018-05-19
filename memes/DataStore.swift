//
//  DataStore.swift
//  memes
//
//  Created by Michael Frick on 19/05/2018.
//  Copyright © 2018 Michael Frick. All rights reserved.
//

import UIKit

struct DataStore {
    private let userDefaults = UserDefaults.standard

    func saveImage(image: UIImage, forName name: String) {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {return}
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
            print("Saved: \(name)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveMemes(_ memes :[Meme]) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: memes)
        userDefaults.set(encodedData, forKey: "memes")
        userDefaults.synchronize()
    }
    
    func loadSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func loadSavedMemes() -> [Meme]{
        var memes: [Meme] = []
        
        if let decoded = userDefaults.object(forKey: "memes") as? Data,
            let decodedMemes = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Meme] {
            memes = decodedMemes
        }
        
        return memes
    }

    func loadMemesWithImages() -> [Meme] {
        var memes = loadSavedMemes()
        
        for i in 0..<memes.count {
            if let image = loadSavedImage(named: "image_\(i).png") {
                print("Load image_\(i).png")
                memes[i].image = image
            }
        }
        
        return memes
    }
}


