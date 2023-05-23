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



class ThumbnailViewController: UIViewController, StoryboardInitializable{
    
    //let thumbnailViewModel = ThumbnailViewModel()
    
    var thumbnailViewModel: ThumbnailViewModel?
    
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var thumbnailImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?

    
        
    //var photos = [Photos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailViewModel?.APIPhotos(UIImageView: thumbnailImageView!)
        titleLabel?.text = thumbnailViewModel?.albumTitle
    }
}
