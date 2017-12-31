//
//  CustomImageView.swift
//  Fire
//
//  Created by Moogun Jung on 6/19/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
//    var keywordFullViewCell: KeywordFullViewCell?
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        // 2 check if cached data already exists
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        // 3 if not, caching data
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            // 1
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
        
    }
}

