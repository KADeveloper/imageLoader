//
//  PhotoListCell.swift
//  ImageLoader
//
//  Created by Динара Аминова on 10.12.2020.
//

import UIKit

class PhotoListCell: UICollectionViewCell {
    //MARK: - Properties
    static var cellID: String { return String(describing: self) }
    
    private let photoImage = UIImageView()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
    }
    
    private func initUI() {
        backgroundColor = .white
        clipsToBounds = true

        
        photoImage.contentMode = .scaleAspectFill
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoImage)
        contentView.addSubview(spinner)
    }
    
    private func initLayout() {
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: topAnchor),
            photoImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImage.heightAnchor.constraint(equalTo: widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func showSpinner() {
        spinner.startAnimating()
    }

    private func hideSpinner() {
        spinner.stopAnimating()
    }
    
    func hideSpinner(withDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.hideSpinner()
        }
    }
    
    func configureCell(image: UIImage) {
        photoImage.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
