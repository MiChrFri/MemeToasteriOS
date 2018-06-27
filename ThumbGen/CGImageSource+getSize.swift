import UIKit

extension CGImageSource {
    
    func size() -> CGSize? {
        guard let properties:NSDictionary = CGImageSourceCopyPropertiesAtIndex(self, 0, nil),
        let width = properties[kCGImagePropertyPixelWidth] as? Int,
        let height = properties[kCGImagePropertyPixelHeight] as? Int else { return nil }
        
        return CGSize(width: width, height: height)
    }
}
