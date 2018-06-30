import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    private var meme: Meme!
    private let dataStore = DataStore()
    
    private lazy var memeView: MemeView = {
        let memeView = MemeView(meme: meme)
        memeView.isUserInteractionEnabled = false
        memeView.contentMode = UIViewContentMode.scaleAspectFill
        memeView.layer.masksToBounds = true
        memeView.translatesAutoresizingMaskIntoConstraints = false
        return memeView
    }()
    
    func composeView(withMeme meme: Meme) {
        self.meme = meme
        backgroundColor = UIColor.white
                
        if let tn = meme.thumbnail {
            let mv = UIImageView(image: tn)

            mv.contentMode = .scaleAspectFill
            mv.clipsToBounds = true
            contentView.addSubview(mv)
            mv.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                mv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
                mv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
                mv.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
                mv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50.0),
                ])
        }
    }
    
}
