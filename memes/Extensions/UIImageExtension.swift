import UIKit

extension UIView {
    
    func render(toSize size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            self.drawHierarchy(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), afterScreenUpdates: true)
        }
    }
    
}

