import UIKit
import Photos

class GalleryViewController: UIViewController {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let imageProvider = ImageProvider()
    let permissionsManager = PermissionManager()
    
    var memes: [Meme] = []
    
    let dataStore = DataStore()
    let memeLoader = MemesLoader()
    
    var memeSize: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = GalleryVC.title
        
        
        permissionsManager.delegate = self
        
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
            self.permissionsManager.handleCameraPermission()
        }))
        imagePickerAlert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (action) in
            self.permissionsManager.handlePhotoLibraryPermission()
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
        collectionView.register(MemeCollectionViewCell.self, forCellWithReuseIdentifier: Strings.memeCellId)
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
            let memeId = UUID().uuidString
            
            let currentDateTiem = Date()
            let meme = Meme(id: memeId, created: currentDateTiem)
            meme.image = img
            
            let editViewController = EditViewController(withMeme: meme)
            editViewController.delegate = self
            self.navigationController?.pushViewController(editViewController, animated: true)
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.memeCellId, for: indexPath) as! MemeCollectionViewCell
        
        if let meme = memes[safe: indexPath.row] {
            cell.composeView(withMeme: meme)
            
            cell.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(removeCell(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func removeCell(sender: UICollectionViewCell) {
        memes.remove(at: sender.tag)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editViewController = EditViewController(withMeme: memes[indexPath.row])
        editViewController.delegate = self
        
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

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {dismiss(animated:false, completion:nil); return }
        
        dismiss(animated:false, completion: { () in
            self.pickedImage(image: pickedImage)
        })
    }
}

extension GalleryViewController: PermissionManagerDelegate {
    func allowed(for sourceType: UIImagePickerControllerSourceType) {
        self.presentImagePicker(withType: sourceType)
    }
    
    func denied(for permissionType: UIImagePickerControllerSourceType) {
        var alertTitle: String
        var alertMessage: String
        
        switch permissionType {
        case .camera:
            alertTitle = "Photos"
            alertMessage = "Allow MemeToaster to access your camera if you want to take photos. You can change the permissions in your settings and try again"
        case .photoLibrary, .savedPhotosAlbum:
            alertTitle = "Photo Library"
            alertMessage = "Allow MemeToaster to access your photo library if you want load and store photos from it. You can change the permissions in your settings and try again"
        }
        
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

extension GalleryViewController: EditViewControllerDelegate {
    func memeSaved(_ meme: Meme) {
        if !self.memes.contains(where: { $0.id == meme.id }) {
            self.memes.insert(meme, at: 0)
        }
    }
}
