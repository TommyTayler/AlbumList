//
//  AlbumListViewController.swift
//  AlbumList
//
//  Created by tommy tayler on 28/01/23.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


//ar albumId = 0



class AlbumListViewController: UITableViewController, StoryboardInitializable {
    
    var albumId = 0
    var albumListViewModel = AlbumListViewModel()
    var albumTitle = ""
    var myIndex = 0
    
    
    @IBOutlet weak var albumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // on load call API
        
        albumListViewModel.APIAlbums {
            self.albumTableView.reloadData()
            print("Album API success")
        }
        albumListViewModel.APIUsers()
    }
    
    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return albumListViewModel.albums.count // [albumList].count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell =  UITableViewCell(style: .default, reuseIdentifier: nil)
        let row = indexPath.row
        let album = albumListViewModel.albums[row]
        var username = albumListViewModel.getUserName(album: album)
        cell.textLabel?.text = "\((username))" + ", Title: " + album.title.capitalized
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        myIndex = indexPath.row
        albumTitle = albumListViewModel.albums[indexPath.row].title
        albumId = albumListViewModel.albums[indexPath.row].id
        print("Album id from didSelectRowAt \(albumId)")
        albumListViewModel.updateAlbumId(albumId: albumId)
        
        // insert func to update AlbumListViewModel albumId
        
        let thumbnailViewController = ThumbnailViewController.storyboardInstantiate()
        let thumbnailViewModel = ThumbnailViewModel()
        thumbnailViewModel.updateThumbnailDetails(albumTitle: albumTitle, albumId: albumId, myId: myIndex) // passes album id, photo to thumbnail view controller
        thumbnailViewController.thumbnailViewModel = thumbnailViewModel
        
        //get albumId
        //pass album Id into updateDetails
        
        navigationController?.pushViewController(thumbnailViewController, animated: true)
        
    }
}
