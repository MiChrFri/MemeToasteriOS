import UIKit

class ViewController: UIViewController {    
    let memeCellId = "cvcid"
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let imagePickerViewController = ImagePickerViewController()
    
    var imagePaths:[String] = []
    var pickedImg: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        addCollectionView()
        showImagePicker()
        imagePickerViewController.delegate = self
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemClicked)), animated: true)
    }
    
    @objc func barButtonItemClicked() {
        showImagePicker()
    }
    
    private func setupView() {
        self.title = "Memes Galery"
        self.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
    
    private func showImagePicker() {
        navigationController?.pushViewController(imagePickerViewController, animated: true)
    }
    
    private final var topPadding: CGFloat {
        get {
            let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 44.0
            let statsBarHeight = UIApplication.shared.statusBarFrame.height
            
            return navBarHeight + statsBarHeight
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
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topPadding).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension ViewController: ImagePickerDelegate {
    func pickedImage(image: UIImage?) {
        if let img = image {
            self.pickedImg.append(img)
            self.collectionView.reloadSections([0])
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickedImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCellId, for: indexPath) as! MemeCollectionViewCell
        if let img = pickedImg[safe: indexPath.row] {
            cell.composeView(withImage: img)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editViewController = EditViewController(withImage: pickedImg[indexPath.row])
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
