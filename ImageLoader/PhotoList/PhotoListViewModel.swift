//
//  PhotoListViewModel.swift
//  ImageLoader
//
//  Created by Динара Аминова on 10.12.2020.
//

import UIKit

struct PhotoListViewModel {
    var model = PhotoListModel()
    
    var needToUpdatePhotos: Bool = false
    var isConnected: Bool = false
    
    func savePhotoInFileManager(photoIndex: Int, image: UIImage) {
        if let data = image.pngData() {
            let document = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let imageUrl = document.appendingPathComponent("photo\(photoIndex).png", isDirectory: true)
            
            do {
                try data.write(to: imageUrl)
            } catch {
                print("Photo not added")
            }
        }
    }
    
    func getPhotoFromFileManager(photoIndex: Int) -> UIImage {
        let document = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageUrl = document.appendingPathComponent("photo\(photoIndex).png", isDirectory: true)
        
        return UIImage(contentsOfFile: imageUrl.path) ?? UIImage.init()
    }
    
    func getPhotosCountFromFileManager() -> Int {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            return fileURLs.count - 1
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return 0
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
