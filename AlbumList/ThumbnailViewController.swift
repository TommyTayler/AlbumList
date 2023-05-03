//
//  ThumbnailViewController.swift
//  AlbumList
//
//  Created by tommy tayler on 28/01/23.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class ThumbnailViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var photos = [Photos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIPhotos()
        titleLabel.text = "Album Name: \((albumTitle))"
        descLabel.text = "DescLabel"
    }
    
    //MARK: - PHOTOS API call
    
    private func APIPhotos() {
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
                let photosResponseModel: [Photos]? = try? jsonDecoder.decode([Photos].self, from: data)
                self.photos = photosResponseModel ?? []
//                DispatchQueue.main.async {
//                    completed()
//                }
                
                // TODO: - Remove variables from func and pass them in when called
                let photo = self.photos[myIndex]
                var thumbnail = ""
                var thumbnailsPhoto = ""
         
                // Loops through user.id and compares
                for photo in self.photos {
                    if albumId == photo.id {
                        thumbnail = photo.thumbnailUrl
                        thumbnailsPhoto = photo.url
                        break
                    }
                }
                self.fetchPhotos(url: thumbnailsPhoto)
                
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

extension ThumbnailViewController {
    func fetchPhotos (url: String) {
        // 1
        let request = AF.request(url)
        // 2
        request.responseImage { response in
            if case .success(let photoImage) = response.result {
                print("image downloaded: \(photoImage)")
                self.thumbnailImageView.image = photoImage
            }
        }
    }
}

//MARK: - Structs

public struct Photos: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
