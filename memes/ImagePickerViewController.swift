import UIKit

protocol ImagePickerDelegate: class {
    func pickedImage(image: UIImage?)
}

class ImagePickerViewController: UIViewController {
    weak var delegate: ImagePickerDelegate?
    
    let imageProvider = ImageProvider()
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCameraSrcButton()
        addLibrarySrcButton()
        
        delegate?.pickedImage(image: nil)
    }
    
    func addCameraSrcButton() {
        let btn = UIButton(frame: CGRect(x: 0, y: 150, width: 50, height: 50))
        btn.backgroundColor = UIColor.green
        btn.addTarget(self, action: #selector(showCameraImagePicker), for: .touchUpInside)
        
        view.addSubview(btn)
    }
    
    func addLibrarySrcButton() {
        let btn = UIButton(frame: CGRect(x: 100, y: 150, width: 50, height: 50))
        btn.backgroundColor = UIColor.orange
        btn.addTarget(self, action: #selector(showLibraryImagePicker), for: .touchUpInside)
        
        view.addSubview(btn)
    }
    
    @objc func showCameraImagePicker() {
        let src = UIImagePickerControllerSourceType.camera
        if let imagePicker = imageProvider.pickerController(from: src ) {
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
    }
    
    @objc func showLibraryImagePicker() {
        let src = UIImagePickerControllerSourceType.photoLibrary
        if let imagePicker = imageProvider.pickerController(from: src ) {
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
    }
}


extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageData = UIImageJPEGRepresentation(pickedImage, 0.6)
        
        if let uiimage = UIImage(data: imageData!) {
            self.pickedImage = uiimage
        }
        
        dismiss(animated:false, completion: { () in
            self.delegate?.pickedImage(image: self.pickedImage)
            self.navigationController?.popViewController(animated: false)
        })
    }
}

