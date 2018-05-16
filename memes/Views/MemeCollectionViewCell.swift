//
//  MemeCollectionViewCell.swift
//  memes
//
//  Created by Michael Frick on 14/05/2018.
//  Copyright © 2018 Michael Frick. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {

    convenience init(withImage image: UIImage) {
        self.init(frame: CGRect.zero)
        composeView(withImage: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func composeView(withImage image: UIImage) {
        let testImageView = UIImageView()
        
        testImageView.image = image
        testImageView.contentMode = UIViewContentMode.scaleAspectFill
        testImageView.layer.masksToBounds = true
        
        self.contentView.addSubview(testImageView)
        
        testImageView.translatesAutoresizingMaskIntoConstraints = false
        testImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
        testImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0).isActive = true
        testImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0).isActive = true
        testImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50.0).isActive = true
        
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

}
