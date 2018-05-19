import UIKit

class ViewController: UIViewController {    
    let memeCellId = "cvcid"
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let imageProvider = ImageProvider()
    
    var imagePaths:[String] = []
    var memes: [Meme] = []
    let dataStore = DataStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        memes = dataStore.loadMemesWithImages()
        
        addCollectionView()
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showImagePicker)), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        DispatchQueue.global(qos: .background).async {
            let userDefaults = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.memes)
            userDefaults.set(encodedData, forKey: "memes")
            userDefaults.synchronize()
            DispatchQueue.main.async {
                self.collectionView.reloadSections([0])
            }
        }
    }

    private func setupView() {
        self.title = "Memes Galery"
    }
    
    @objc private func showImagePicker() {
        let imagePicker = UIAlertController(title: "Select an Image", message: nil, preferredStyle: .actionSheet)
        
        imagePicker.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        imagePicker.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action) in
            self.presentImagePicker(withType: .camera)
        }))
        imagePicker.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (action) in
            self.presentImagePicker(withType: .photoLibrary)
        }))
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentImagePicker(withType type: UIImagePickerControllerSourceType) {
        if let imagePicker = self.imageProvider.pickerController(from: type ) {
            imagePicker.delegate = self
            self.present(imagePicker, animated: false)
        }
    }
    
    func addCollectionView() {
        collectionView.register(MemeCollectionViewCell.self, forCellWithReuseIdentifier: memeCellId)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        self.view.addSubview(collectionView)
  
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func pickedImage(image: UIImage?) {
        if let img = image {
            let imageName = "image_\(memes.count).png"
            let meme = Meme(imageName: imageName)
            meme.image = img

            self.memes.insert(meme, at: 0)
            self.collectionView.reloadSections([0])

            dataStore.saveImage(image: img, forName: imageName)
            dataStore.saveMemes(self.memes)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCellId, for: indexPath) as! MemeCollectionViewCell
        if let meme = memes[safe: indexPath.row] {
            cell.composeView(withMeme: meme)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editViewController = EditViewController(withMeme: memes[indexPath.row])
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width - 32.0
        
        return CGSize(width: width, height: width)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {dismiss(animated:false, completion:nil); return }
        
        let imageData = UIImageJPEGRepresentation(pickedImage, 0.6)
        dismiss(animated:false, completion: { () in
            self.pickedImage(image: UIImage(data: imageData!))
        })
    }
}
