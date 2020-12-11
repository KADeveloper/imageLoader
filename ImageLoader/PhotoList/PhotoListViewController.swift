//
//  PhotoListViewController.swift
//  ImageLoader
//
//  Created by Динара Аминова on 10.12.2020.
//

import UIKit
import Network

class PhotoListViewController: UIViewController {
    private let mainView = PhotoListView()
    private var viewModel = PhotoListViewModel()
    
    private var screenWidth = UIScreen.main.bounds.width
    private let refreshControl = UIRefreshControl()
    private let monitor = NWPathMonitor()
    
    //MARK: - Life cycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photos"
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.refreshControl = refreshControl
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise")?.withTintColor(.black),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(refreshPhotoList))
        
        refreshControl.addTarget(self, action: #selector(refreshPhotoList), for: .valueChanged)
        
        startMonitor()
        checkInternetConnection()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        screenWidth = UIScreen.main.bounds.width
        mainView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - Methods
    private func requestPhotoList() {
        NetworkManager.getPhotoList() { (photoList, error) in
            guard let photoList = photoList else {
                DispatchQueue.main.async {
                    self.showAlert(message: error?.localizedDescription ?? "Bad request")
                }
                return
            }
            DispatchQueue.main.async {
                if self.viewModel.model.photos.photo != photoList.photos.photo {
                    self.viewModel.needToUpdatePhotos = true
                } else {
                    self.viewModel.needToUpdatePhotos = false
                }
                
                self.viewModel.model = photoList
                self.mainView.hideSpinner(withDelay: 0.2)
                self.mainView.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: .none, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { _ in
            self.mainView.hideSpinner(withDelay: 0.2)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func loadPhoto(farm_id: String, server_id: String, id: String, secret: String, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            guard let url = NetworkManager.requestType.getChoosedPhoto(farm_id, server_id, id, secret).url else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    @objc private func refreshPhotoList() {
        if !viewModel.isConnected {
            startMonitor()
            checkInternetConnection()
        } else {
            mainView.showSpinner()
            requestPhotoList()
        }
    }
    
    private func checkInternetConnection() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.mainView.showSpinner()
                    self?.viewModel.isConnected = true
                    self?.requestPhotoList()
                    self?.stopMonitor()
                }
            } else {
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                    self?.viewModel.isConnected = false
                }
            }
        }
    }
    
    private func startMonitor() {
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    private func stopMonitor() {
        self.monitor.cancel()
    }
}

//MARK: - UICollectionViewDataSource, UICollisionBehaviorDelegate, UICollectionViewDelegateFlowLayout
extension PhotoListViewController: UICollectionViewDataSource, UICollisionBehaviorDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.isConnected {
        case true:
            return viewModel.model.photos.photo.count
        case false:
            return viewModel.getPhotosCountFromFileManager()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCell.cellID, for: indexPath)
        if let cell = cell as? PhotoListCell {
            if viewModel.needToUpdatePhotos && viewModel.isConnected {
                cell.showSpinner()
                let model = viewModel.model.photos.photo[indexPath.row]
                self.loadPhoto(farm_id: String(model.farm), server_id: model.server, id: model.id, secret: model.secret) { [weak self] image in
                    guard let image = image else { return }
                    cell.hideSpinner(withDelay: 0.2)
                    self?.viewModel.savePhotoInFileManager(photoIndex: indexPath.row, image: image)
                    cell.configureCell(image: image)
                }
            } else {
                cell.configureCell(image: viewModel.getPhotoFromFileManager(photoIndex: indexPath.row))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cachedImage = viewModel.getPhotoFromFileManager(photoIndex: indexPath.row)
        let viewModel = ChoosedPhotoViewModel(cachedPhoto: cachedImage)
        let vc = ChoosedPhotoViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch UIDevice.current.orientation{
        case .portrait:
            return screenWidth * 0.1
        case .landscapeLeft, .landscapeRight:
            return screenWidth * 0.04
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIDevice.current.orientation{
        case .portrait:
            return CGSize(width: screenWidth * 0.35,
                          height: screenWidth * 0.35)
        case .landscapeLeft, .landscapeRight:
            return CGSize(width: screenWidth * 0.2,
                          height: screenWidth * 0.2)
        default:
            return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch UIDevice.current.orientation{
        case .portrait:
            return UIEdgeInsets(top: 0,
                                left: screenWidth * 0.1,
                                bottom: 0,
                                right: screenWidth * 0.1)
        case .landscapeLeft, .landscapeRight:
            return UIEdgeInsets(top: 0,
                                left: screenWidth * 0.04,
                                bottom: 0,
                                right: screenWidth * 0.04)
        default:
            return UIEdgeInsets.zero
        }
    }
}
