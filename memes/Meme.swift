import UIKit

class Meme {
    let image: UIImage!
    let topText: String!
    let bottomText: String!
    
    init(image: UIImage, topText: String, bottomText: String) {
        self.image = image
        self.topText = topText
        self.bottomText = bottomText
    }
}
