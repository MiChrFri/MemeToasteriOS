//
//  ThumbGen.swift
//  ThumbGen
//
//  Created by Michael Frick on 27/06/2018.
//

public struct ThumbGenerator {
    
    public init() {}
    
    public func thumbnailFrom(path filePath: NSURL, outputSize size: CGSize) -> UIImage? {
        if let imageSource = CGImageSourceCreateWithURL(filePath, nil) {
            return createThumbnail(imageSource: imageSource, withSize: size)
        }
        return nil
    }
    
    public func createThumbnail(imageSource:CGImageSource, withSize size: CGSize) -> UIImage? {
        
        let sizeOfTumbnailInPixel = ImageFitting().thumbnailPixelSize(imageSourceSize: imageSource.size()!, fixedThumbailSize: size.pixelValue)
        
        let maxSize = ImageFitting().maxThumbnailSize(outputFrameSize: sizeOfTumbnailInPixel)
        
        return createThumbImage(imageSource: imageSource, maxSize: maxSize, outputFrameSize: size.pixelValue)
    }
    
    private func createThumbImage(imageSource:CGImageSource, maxSize:CGFloat, outputFrameSize: CGSize) -> UIImage? {
        let options = [
            kCGImageSourceThumbnailMaxPixelSize as String : maxSize,
            kCGImageSourceCreateThumbnailFromImageIfAbsent as String : true
            ] as [String : Any]
        
        
        if let thumbImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
            
            let marginX = (CGFloat(thumbImage.width) - outputFrameSize.width)/2
            let marginY = (CGFloat(thumbImage.height) - outputFrameSize.height)/2
            
            let cropRect = CGRect(
                x: marginX > 0 ? marginX : 0,
                y: marginY > 0 ? marginY : 0,
                width: outputFrameSize.width,
                height: outputFrameSize.height
            )
            
            if let cgImage = thumbImage.cropping(to: cropRect) {
                let image = UIImage(cgImage: cgImage)
                return image
            }
        }
        return nil
    }
}
