import UIKit

extension CGSize {
    
    var pixelValue: CGSize {
        get {
            return CGSize(width: self.width * DeviceInfo.ScaleFactor, height: self.height * DeviceInfo.ScaleFactor)
        }
    }
}

