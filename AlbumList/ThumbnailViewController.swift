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
}

// MARK: - Extension

extension ThumbnailViewController {
    func fetchPhotos () {
        // 1
        print("myIndex = \(myIndex)")
        
        let request = AF.request("https://via.placeholder.com/600/92c952") // update this to use the table view cells index thumbnail rather than hard code
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
