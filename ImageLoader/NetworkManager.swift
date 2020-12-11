//
//  NetworkManager.swift
//  ImageLoader
//
//  Created by Динара Аминова on 10.12.2020.
//

import UIKit

struct NetworkManager {
    enum requestType {
        case getPhotosList
        case getChoosedPhoto(String, String, String, String)
        
        var url: URL? {
            return URL(string: self.APIValue)
        }
        
        var APIValue: String {
            switch self {
            case .getPhotosList:
                return "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=da9d38d3dee82ec8dda8bb0763bf5d9c&format=json&nojsoncallback=1&per_page=20"
            case .getChoosedPhoto(let farm_id, let server_id, let id, let secret):
                return "https://farm\(farm_id).staticflickr.com/\(server_id)/\(id)_\(secret).jpg"
            }
        }
    }
    
    static func getPhotoList(completion: @escaping (PhotoListModel?, Error?) -> Void) {
        guard let url = requestType.getPhotosList.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            do {
                guard let userData = data else { return }
                let data = try JSONDecoder().decode(PhotoListModel.self, from: userData)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
