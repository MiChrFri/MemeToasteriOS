import UIKit

class Meme: NSObject, NSCoding {
    let id: String!
    var topText: String!
    var bottomText: String!
    var image: UIImage?
    var thumbnail: UIImage?
    
    init(id: String, topText: String = "your text", bottomText: String = "your text") {
        self.id = id
        self.topText = topText
        self.bottomText = bottomText
    }
    
    internal func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(topText, forKey: "topText")
        aCoder.encode(bottomText, forKey: "bottomText")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let topText = aDecoder.decodeObject(forKey: "topText") as! String
        let bottomText = aDecoder.decodeObject(forKey: "bottomText") as! String
        
        self.init(id: id, topText: topText, bottomText: bottomText)
    }
    
}
