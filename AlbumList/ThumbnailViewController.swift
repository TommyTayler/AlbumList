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
        //APIPhotos()
        fetchPhotos()
        // Do any additional setup after loading the view.
        
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
                let photoResponseModel: [Photos]? = try? jsonDecoder.decode([Photos].self, from: data)
                print(photoResponseModel)
                self.photos = photoResponseModel ?? []
//                DispatchQueue.main.async {
//                    completed()
//                }
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
    func fetchPhotos () {
        // 1
        let request = AF.request("https://via.placeholder.com/600/92c952")
        // 2
        request.responseImage { response in
            debugPrint(response)
    
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
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
    let thumbnailUrl: String
}
