//
//  ThumbnailViewModel.swift
//  AlbumList
//
//  Created by tommy tayler on 15/05/23.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class ThumbnailViewModel {
    
    var albumId = 0
    var albumTitle = ""
    var myId = 0
    var photos = [Photo]()


    
    
    //MARK: - Helper functions
    
    public func updateThumbnailDetails(albumTitle: String, albumId: Int, myId: Int) { // Index(change name), album id
        self.albumTitle = "Album title: \(albumTitle.capitalized)"
        self.albumId = albumId
        self.myId = myId
    }
    
    //MARK: - PHOTO API call
    
    public func APIPhotos(UIImageView: UIImageView) {
        
        let UIImageView = UIImageView // is this needed, I'm not sure I'm doing this right
        var thumbnail = ""
        var thumbnailsPhoto = ""
        
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            // TODO: Error handling - not valid URL
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let httpResponse = response as? HTTPURLResponse else {
                // TODO: Error handling - not valid response
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    // TODO: Error handling
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                let photosResponseModel: [Photo]? = try? jsonDecoder.decode([Photo].self, from: data)
                self.photos = photosResponseModel ?? []
                _ = self.photos[self.myId]
                let albumId = self.albumId

                // Loops through user.id and compares
                for photo in self.photos {
                    if albumId == photo.id {
                        thumbnail = photo.thumbnailUrl
                        thumbnailsPhoto = photo.url
                        break
                    }
                }
                self.fetchPhotos(url: thumbnailsPhoto, UIImageView: UIImageView)
                
                print("Photo API Called")
            default:
                // TODO: Error handling - invalid response
                return
            }
        })

        task.resume()
    }
}

// MARK: - Extension

extension ThumbnailViewModel {
    func fetchPhotos (url: String, UIImageView: UIImageView) {
        let thumbnailImageView = UIImageView
        // 1
        let request = AF.request(url)
        // 2
        request.responseImage { response in
            if case .success(let photoImage) = response.result {
                print("image downloaded: \(photoImage)")
                thumbnailImageView.image = photoImage
            }
        }
    }
}
