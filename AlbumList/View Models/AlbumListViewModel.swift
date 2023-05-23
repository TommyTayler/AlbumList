//
//  AlbumListViewModel.swift
//  AlbumList
//
//  Created by tommy tayler on 15/05/23.
//

import Foundation

class AlbumListViewModel {
    
    var albumId = 0
    var albums = [Album]()
    var users = [User]()
    
    // MARK: - Helper functions
    
    func updateAlbumId(albumId: Int) {
        self.albumId = albumId
        print("updateAlbumId Album Id: \(albumId)")
    }
    
    func getAlbumId() -> Int {
        return albumId
    }
    
    //MARK: - Albums API call
    
    public func APIAlbums(completed: @escaping () -> ()) {
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
                self.albums = responseModel!
                
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
    
    public func APIUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            // TODO: EralbumIdror handling - not valid URL
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
                self.users = userResponseModel ?? []
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
    
    func getUserName(album: Album) -> String {
        var username = ""
        // TODO: Move this to view Model
        // Loops through user.id and compares
        for user in users {
            if album.userId == user.id {
                username = user.name
            }
        }
        return username
    }
}
