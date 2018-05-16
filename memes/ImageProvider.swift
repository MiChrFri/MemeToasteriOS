import UIKit

struct ImageProvider {
    func pickerController(from source: UIImagePickerControllerSourceType) -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return nil }
        
        let pickerController = UIImagePickerController()
        pickerController.sourceType = source;
        pickerController.allowsEditing = false
    
        return pickerController
    }
}
