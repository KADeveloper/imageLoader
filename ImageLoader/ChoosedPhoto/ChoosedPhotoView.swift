//
//  ChoosedPhotoView.swift
//  ImageLoader
//
//  Created by Динара Аминова on 10.12.2020.
//

import UIKit

class ChoosedPhotoView: UIView {
    private let choosedPhotoImage = UIImageView()
    
    init() {
        super.init(frame: CGRect.zero)
        
        initUI()
        initLayout()
    }
    
    override func layoutSubviews() {
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        backgroundColor = .white
        
        choosedPhotoImage.contentMode = .scaleAspectFit
        choosedPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(choosedPhotoImage)
    }
    
    private func initLayout() {
        NSLayoutConstraint.activate([
            choosedPhotoImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            choosedPhotoImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            choosedPhotoImage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            choosedPhotoImage.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor)
        ])
    }
    
    func configurePhotoView(with photo: UIImage) {
        choosedPhotoImage.image = photo
    }
}
