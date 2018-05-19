import UIKit

class Meme: NSObject, NSCoding {
    let imageName: String!
    var topText: String!
    var bottomText: String!
    var image: UIImage?
    
    init(imageName: String, topText: String = "your text", bottomText: String = "your text") {
        self.imageName = imageName
        self.topText = topText
        self.bottomText = bottomText
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(topText, forKey: "topText")
        aCoder.encode(bottomText, forKey: "bottomText")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let imageName = aDecoder.decodeObject(forKey: "imageName") as! String
        let topText = aDecoder.decodeObject(forKey: "topText") as! String
        let bottomText = aDecoder.decodeObject(forKey: "bottomText") as! String
        
        self.init(imageName: imageName, topText: topText, bottomText: bottomText)
    }
}
