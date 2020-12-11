//
//  PhotoListModel.swift
//  ImageLoader
//
//  Created by Динара Аминова on 10.12.2020.
//

import Foundation

class PhotoListModel: Codable {
    var photos: Photos = Photos()
}

class Photos: Codable {
    var photo: [Photo] = []
}

class Photo: Codable, Equatable  {
    var id: String = ""
    var secret: String = ""
    var server: String = ""
    var farm: Int = 0
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.farm == rhs.farm && lhs.secret == rhs.secret && lhs.server == rhs.server && lhs.id == rhs.id
    }
}
