import Foundation
import AVFoundation


protocol PermissionManagerDelegate: class {
    
    func cameraUsageGranted()
    func cameraUsageDenied()
}

class PermissionManager {
    weak var delegate: PermissionManagerDelegate?
    
    func handleCameraPermission() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            delegate?.cameraUsageDenied()
        case .authorized:
            delegate?.cameraUsageGranted()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    self.delegate?.cameraUsageGranted()
                } else {
                    self.delegate?.cameraUsageDenied()
                }
            }
        }
    }
    
}


