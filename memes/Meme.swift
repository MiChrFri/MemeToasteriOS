import UIKit

class Meme {
    let image: UIImage!
    var topText: String!
    var bottomText: String!
    
    init(image: UIImage, topText: String = "your text", bottomText: String = "your text") {
        self.image = image
        self.topText = topText
        self.bottomText = bottomText
    }
}
