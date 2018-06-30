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
            if let imagePath = directory.appendingPathComponent(name) {
                try data.write(to: imagePath)
                print("Saved--: \(name)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveMemes(_ memes :[Meme]) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: memes)
        userDefaults.set(encodedData, forKey: "memes")
        userDefaults.synchronize()
    }
    
}


