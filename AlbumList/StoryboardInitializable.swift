//
//  StoryboardInitializable.swift
//  AlbumList
//
//  Created by tommy tayler on 14/04/23.
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self) //comes from file name
    }
    
    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        guard
            let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self
            else { fatalError("Couldn't instantiate \(name) from \(storyboardIdentifier)") }
        return vc
    }
    
    static func storyboardInstantiate() -> Self {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        guard
            let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self
            else { fatalError("Couldn't instantiate \(storyboardIdentifier)") }
        return vc
    }
}
