//
//  ChoosedPhotoViewController.swift
//  ImageLoader
//
//  Created by Динара Аминова on 10.12.2020.
//

import UIKit

class ChoosedPhotoViewController: UIViewController {
    private let mainView = ChoosedPhotoView()
    private var viewModel: ChoosedPhotoViewModel
    
    //MARK: - Life cycle
    init(viewModel: ChoosedPhotoViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choosed photo"
        
        mainView.configurePhotoView(with: viewModel.cachedPhoto)
    }
}
