//
//  AlbumListViewController.swift
//  AlbumList
//
//  Created by tommy tayler on 28/01/23.
//

import UIKit

var albumTitle = ""
var albumId = 0
var myIndex = 0

class AlbumListViewController: UITableViewController, StoryboardInitializable {


    var albums = [Album]()
    var users = [User]()
    
    
    
    @IBOutlet weak var albumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // on load call API
        
        APIAlbums {
            self.albumTableView.reloadData()
            print("Albums success")
        }
        APIUsers()
    }
    
    // MARK: - Table View Data Source
    override func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        return albums.count // [albumList].count
    }

    override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell =  UITableViewCell(style: .default, reuseIdentifier: nil)
        let row = indexPath.row
        let album = albums[row]
        var username = ""
 
        // Loops through user.id and compares 
        for user in users {
            if album.userId == user.id {
                username = user.name
            }
        }
        
        cell.textLabel?.text = "\((username))" + ", Title: " + album.title.capitalized
        return cell
    }
    
    // MARK: - Table View Delegate
    
//    override func tableView(
//        _ tableView: UITableView,
//        didSelectRowAt indexPath: IndexPath
//    ) {
//        let thumbnailViewController = ThumbnailViewController.storyboardInstantiate()
//        navigationController?.pushViewController(thumbnailViewController, animated: true)
//
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        albumTitle = albums[indexPath.row].title
        albumId = albums[indexPath.row].id
        print("Index: \((myIndex))")
        print("Album Title: \((albumTitle))")
        print("Album Id: \((albumId))")
       
        
        
        performSegue(withIdentifier: "segue", sender: self)
        
        
    }
    
    //MARK: - Albums API call
    
    private func APIAlbums(completed: @escaping () -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums") else {
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
                let responseModel = try? jsonDecoder.decode([Album].self, from: data)
                //print(responseModel)
                self.albums = responseModel! // Ask Haydon to explain this as I don't understand
                
                DispatchQueue.main.async {
                    completed()
                }
                
            default:
                // TODO: Error handling - invalid response
                return
            }
        })

        task.resume()
    }
    
    //MARK: - USER API call
    
    private func APIUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
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
                let userResponseModel: [User]? = try? jsonDecoder.decode([User].self, from: data)
                print(userResponseModel)
                self.users = userResponseModel ?? [] // Ask Haydon to explain the !, aviod ! everywhere
//                DispatchQueue.main.async {
//                    completed()
//                }
                print("User API Called")
            default:
                // TODO: Error handling - invalid response
                return
            }
        })

        task.resume()
    }
}

//MARK: - Structs

public struct Album: Codable {
    let userId: Int
    let id: Int
    let title: String
}

public struct User: Codable {
    let id: Int
    let name: String
}


