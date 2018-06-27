import UIKit

struct ImageFitting {
    
    func maxThumbnailSize(outputFrameSize size: CGSize) -> CGFloat {
        return size.width > size.height ? size.width : size.height
    }
    
    func thumbnailPixelSize(imageSourceSize:CGSize, fixedThumbailSize size: CGSize) -> CGSize {
        let widthDifference = size.width - imageSourceSize.width
        let heightDifference = size.height - imageSourceSize.height
        
        var scaleSize:CGSize
        
        if widthDifference > heightDifference {
            scaleSize = CGSize(width: size.width, height: size.width * imageSourceSize.aspectRatio)
        } else if abs(heightDifference/widthDifference) < imageSourceSize.aspectRatio {
            if size.width < size.height {
                 scaleSize = CGSize(width: size.height * imageSourceSize.aspectRatio, height: size.height )
            } else {
                 scaleSize = CGSize(width: size.width, height: size.width * imageSourceSize.aspectRatio)
            }
        } else {
            scaleSize = CGSize(width: size.height * imageSourceSize.aspectRatio, height: size.height)
        }
        

        return scaleSize
    }
}
