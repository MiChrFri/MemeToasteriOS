import UIKit

class MemeView: UIView, UITextViewDelegate {
    private let meme: Meme!
    private var topTextView: UITextView?
    private var bottomTextView: UITextView?
    private let imageView = UIImageView(frame: CGRect.zero)
    private let editable: Bool!
    
    private lazy var titleTextView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.textContainer.maximumNumberOfLines = 3
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.font = Fonts.main
        textView.isEditable = true
        textView.autocapitalizationType = .allCharacters
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        
        return textView
    }()

    init(meme: Meme, editable: Bool = false) {
        self.meme = meme
        self.editable = editable
        super.init(frame: CGRect.zero)
        
        let titleTop = createTitle(at: .top)
        imageView.addSubview(titleTop)
        setupTextViewLayout(titleTop, position: .top)
        
        let titleBottom = createTitle(at: .bottom)
        imageView.addSubview(titleBottom)
        setupTextViewLayout(titleBottom, position: .bottom)
        
        addImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addImageView() {
        imageView.image = meme.image
    
        imageView.isUserInteractionEnabled = editable
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

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
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.endEditing(true)
        
        if let topText = topTextView?.text {
            meme.topText = topText
        }
        
        if let bottomText = bottomTextView?.text {
            meme.bottomText = bottomText
        }
    }

    private func createTitle(at position:LabelPosition) -> UITextView {
        let textView = titleTextView
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

        return textView
    }
    
    private func setupTextViewLayout(_ textView: UITextView, position: LabelPosition) {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        switch position {
        case .top: textView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        case .bottom: textView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        }
    }
}

extension MemeView {
    struct Const {
        struct Shadow {
            static let radius:CGFloat = 2.0
            static let color = UIColor.black.cgColor
            static let offset = CGSize(width: 2, height: 2)
            static let opacity:Float = 0.3
        }
    }
}
