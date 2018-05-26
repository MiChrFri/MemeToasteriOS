import UIKit

class NoMemeCollectionViewCell: UICollectionViewCell {
    func composeView() {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(named: "noImages.png")
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
    }
}
