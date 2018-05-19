import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    func composeView(withMeme meme: Meme) {
        backgroundColor = UIColor.white
        
        let memeView = MemeView(meme: meme)
        memeView.isUserInteractionEnabled = false
        memeView.contentMode = UIViewContentMode.scaleAspectFill
        memeView.layer.masksToBounds = true
        self.contentView.addSubview(memeView)
        
        memeView.translatesAutoresizingMaskIntoConstraints = false
        memeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
        memeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0).isActive = true
        memeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0).isActive = true
        memeView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50.0).isActive = true
    }
}
