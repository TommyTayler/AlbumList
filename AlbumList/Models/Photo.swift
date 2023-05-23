//
//  Photos.swift
//  AlbumList
//
//  Created by tommy tayler on 15/05/23.
//

import Foundation

public struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
