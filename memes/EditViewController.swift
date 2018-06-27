import UIKit

enum LabelPosition {
    case top, bottom
}

class EditViewController: UIViewController, UITextViewDelegate {
    private let dataStore = DataStore()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background
        view.tintColor = Colors.buttonText
        
        setupNavigationBar()
        addImageView()
        self.topTextView = addTextView(at: .top)
        self.bottomTextView = addTextView(at: .bottom)
    }
    
    private func setupNavigationBar() {
        title = Const.title
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(barButtonItemClicked)), animated: true)
    }
    
    private func addImageView() {
        imageView.image = meme.image
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        imageView.layer.shadowColor = Const.Shadow.color
        imageView.layer.shadowOffset = Const.Shadow.offset
        imageView.layer.shadowOpacity = Const.Shadow.opacity
        imageView.layer.shadowRadius = Const.Shadow.radius
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
    @objc func barButtonItemClicked() {
        
        let newSize = CGSize(width: imageView.frame.size.width-80.0, height: imageView.frame.size.height-80.0)

        let image = imageView.render(toSize: newSize)
        
        dataStore.saveImage(image: image, forName: "thumb_\(meme.id ?? "").png")
        meme.thumbnail = image
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

// CONSTANTS
extension EditViewController {
    struct Const {
        static let title = "Edit meme"
        
        struct Shadow {
            static let radius:CGFloat = 2.0
            static let color = UIColor.black.cgColor
            static let offset = CGSize(width: 2, height: 2)
            static let opacity:Float = 0.3
        }
    }
}




