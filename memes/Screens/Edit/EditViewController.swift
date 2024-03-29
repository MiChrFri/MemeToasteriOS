import UIKit

enum LabelPosition {
    case top, bottom
}

protocol EditViewControllerDelegate: class {
    func memeSaved(_ meme: Meme)
}

class EditViewController: UIViewController, UITextViewDelegate {
    weak var delegate: EditViewControllerDelegate?
    
    private let dataStore = DataStore()
    private let imageLoader = ImageLoader()
    private let permissionManager = PermissionManager()
    
    private var saveBtn: UIBarButtonItem!
    private let meme: Meme!
    private var topTextView: UITextView?
    private var bottomTextView: UITextView?
    private let imageView = UIImageView(frame: CGRect.zero)
    
    init(withMeme meme: Meme) {
        self.meme = meme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var saveImageButton: UIButton = {
        let saveImageButton = UIButton(frame: CGRect.zero)
        saveImageButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        saveImageButton.layer.cornerRadius = 50
        saveImageButton.layer.masksToBounds = true
        saveImageButton.setTitle("📥", for: .normal)
        saveImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 60.0)
        saveImageButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)

        saveImageButton.translatesAutoresizingMaskIntoConstraints = false
        return saveImageButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background
        view.tintColor = Colors.buttonText
        
        permissionManager.delegate = self
        
        setupNavigationBar()
        addImageView()
        self.topTextView = addTextView(at: .top)
        self.bottomTextView = addTextView(at: .bottom)
        
        let saveToImages = saveImageButton
        self.view.addSubview(saveToImages)
        
        saveToImages.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        saveToImages.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveToImages.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveToImages.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc private func saveImage() {
        permissionManager.handlePhotoLibraryPermission()
    }
    
    private func setupNavigationBar() {
        title = EditVC.title
        
        saveBtn = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(saveClicked))
        navigationItem.setRightBarButton(saveBtn, animated: true)
    }
    
    private func addImageView() {
        if meme.image == nil, let memeId = meme.id {
            if let image = imageLoader.get(byName: "\(Images.img)\(memeId)\(Images.pngType)") {
                meme.image = image
            }
        }
        
        imageView.image = meme.image
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        imageView.layer.shadowColor = EditVC.Shadow.color
        imageView.layer.shadowOffset = EditVC.Shadow.offset
        imageView.layer.shadowOpacity = EditVC.Shadow.opacity
        imageView.layer.shadowRadius = EditVC.Shadow.radius
        imageView.clipsToBounds = false
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        imageView.addGestureRecognizer(tap)
    }
    
    private func addTextView(at position:LabelPosition) -> UITextView {
        let textView = UITextView(frame: CGRect.zero)
        textView.delegate = self
        
        if let txt = position == .top ? meme.topText : meme.bottomText {
            let attributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeWidth.rawValue):  -3.0,
                NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeColor.rawValue): UIColor.black,
                NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white
            ]
            
            let attrStr = NSAttributedString(string: txt, attributes: attributes)
            textView.attributedText = attrStr
        }
        
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.textContainer.maximumNumberOfLines = 3
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.font = Fonts.main
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        
        imageView.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        switch position {
            case .top: textView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
            case .bottom: textView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        }
        
        return textView
    }
}

// HANDLERS
extension EditViewController {
    @objc func saveClicked() {
        view.endEditing(true)
        
        let newSize = CGSize(width: imageView.frame.size.width, height: imageView.frame.size.height)
        
        let thumbGenerator = ThumbGenerator()
        
        let image = imageView.render(toSize: newSize)
        let imgData: CFData = UIImagePNGRepresentation(image)! as CFData
        let imgSource = CGImageSourceCreateWithData(imgData, nil)
        
        let ns = CGSize(width: newSize.width/DeviceInfo.ScaleFactor, height: newSize.width/DeviceInfo.ScaleFactor)
        
        let thumb = thumbGenerator.createThumbnail(imageSource: imgSource!, withSize: ns)
        
        if let memeId = meme.id {
            if let img = meme.image, let thumb = thumb {
                dataStore.saveImage(image: img, forName: "\(Images.img)\(memeId)\(Images.pngType)")
                dataStore.saveImage(image: thumb, forName: "\(Images.thumb)\(memeId)\(Images.pngType)")
                
                saveBtn.title = "✓"
                meme.thumbnail = thumb
                delegate?.memeSaved(meme)
            }
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
        
        if let topText = topTextView?.text {
            meme.topText = topText
        }
        
        if let bottomText = bottomTextView?.text {
            meme.bottomText = bottomText
        }
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "✔︎", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.saveBtn.title = "save"
        
        if meme.topText == "your text" || meme.bottomText == "your text" {
            textView.text = nil
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.autocapitalizationType != .allCharacters {
            textView.autocapitalizationType = .allCharacters
            textView.resignFirstResponder()
            textView.becomeFirstResponder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.clear
    }
}

extension EditViewController: PermissionManagerDelegate {
    func allowed(for sourceType: UIImagePickerControllerSourceType) {
        imageView.layoutIfNeeded()
        let img = imageView.render(toSize: imageView.frame.size)
        
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func denied(for sourceType: UIImagePickerControllerSourceType) {
        let alertTitle = "Photo Library"
        let alertMessage = "Allow MemeToaster to access your photo library if you want load and store photos from it. You can change the permissions in your settings and try again"
        
        let errorAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        errorAlert.view.tintColor = Colors.buttonText
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        errorAlert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (action) in
            let app = UIApplication.shared
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            
            app.open(settingsUrl!, options: [:], completionHandler: nil)
        }))
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
}
