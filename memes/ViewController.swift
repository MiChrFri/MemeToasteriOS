import UIKit

class ViewController: UIViewController {    
    let memeCellId = "memecCellId"
    let noMemeCellId = "noMemecCellId"
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let imageProvider = ImageProvider()
    
    var imagePaths:[String] = []
    var memes: [Meme] = []
    
    let dataStore = DataStore()
    let memeLoader = MemesLoader()
    
    var memeSize: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Memes Galery"
        
        memes = memeLoader.getAll()
        
        addCollectionView()
        setupLayout()
        
        memeSize = CGSize(width: UIScreen.main.bounds.width - 32.0, height: UIScreen.main.bounds.width - 32.0)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showImagePicker)), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if memes.count > 0 {
            dataStore.saveMemes(self.memes)
            self.collectionView.reloadSections([0])
        }
    }
    
    @objc private func showImagePicker() {
        let imagePickerAlert = UIAlertController(title: "Select an Image", message: nil, preferredStyle: .alert)
        
        imagePickerAlert.view.tintColor = Colors.buttonText
        imagePickerAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        imagePickerAlert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action) in
            self.presentImagePicker(withType: .camera)
        }))
        imagePickerAlert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (action) in
            self.presentImagePicker(withType: .photoLibrary)
        }))
        
        self.present(imagePickerAlert, animated: true, completion: nil)
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
        collectionView.backgroundColor = Colors.background
        
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        self.view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func pickedImage(image: UIImage?) {
        if let img = image {
    
            // TODO: Unique meme id
            let memeId = UUID().uuidString
            
            let imageName = "image_\(memeId).png"
            let meme = Meme(id: memeId)
            meme.image = img

            dataStore.saveImage(image: img, forName: imageName)            
            self.memes.insert(meme, at: 0)
            
            let editViewController = EditViewController(withMeme: meme)
            self.navigationController?.pushViewController(editViewController, animated: true)
        }
    }
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(frame: CGRect.zero)
        deleteButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        deleteButton.isUserInteractionEnabled = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if memes.count == 0 {
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "noImages");
            bgImage.contentMode = .scaleAspectFit
            collectionView.backgroundView = bgImage
        } else {
            collectionView.backgroundView = nil
        }
        
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCellId, for: indexPath) as! MemeCollectionViewCell
        
        if let meme = memes[safe: indexPath.row] {
            cell.composeView(withMeme: meme)
            
            cell.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(removeCell(sender:)), for: .touchUpInside)
        }

        return cell
    }
    
    @objc func removeCell(sender: UICollectionViewCell) {
        print(sender.tag)
        memes.remove(at: sender.tag)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editViewController = EditViewController(withMeme: memes[indexPath.row])
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width - 32.0
        
        return CGSize(width: width, height: width + 60)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {dismiss(animated:false, completion:nil); return }
        
        dismiss(animated:false, completion: { () in
            self.pickedImage(image: pickedImage)
        })
    }
}
