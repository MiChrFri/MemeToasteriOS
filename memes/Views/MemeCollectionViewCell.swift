import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    private var meme: Meme!
    private let dataStore = DataStore()
    
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel(frame: CGRect.zero)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm - MMMM d, yyyy"
        infoLabel.text = dateFormatter.string(from: meme.created)
        infoLabel.font = UIFont.systemFont(ofSize: 18.0)
        infoLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        return infoLabel
    }()

    lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(frame: CGRect.zero)
        deleteButton.setTitle("🗑", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 24.0)
        deleteButton.isUserInteractionEnabled = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    
    func composeView(withMeme meme: Meme) {
        self.meme = meme
        backgroundColor = UIColor.white
        
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = Colors.lightGrey.cgColor
        self.contentView.layer.masksToBounds = true
                
        if let tn = meme.thumbnail {
            let mv = UIImageView(image: tn)

            mv.contentMode = .scaleAspectFill
            mv.clipsToBounds = true
            contentView.addSubview(mv)
            mv.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(infoLabel)
            contentView.addSubview(deleteButton)
            
            NSLayoutConstraint.activate([
                mv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
                mv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
                mv.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
                mv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50.0),
                
                infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
                infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0),
                infoLabel.heightAnchor.constraint(equalToConstant: 50.0),
                
                deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
                deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0),
                deleteButton.widthAnchor.constraint(equalToConstant: 50.0),
                deleteButton.heightAnchor.constraint(equalToConstant: 50.0),
                ])
        }
    }
    
}
