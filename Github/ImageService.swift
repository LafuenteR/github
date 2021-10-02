//
//  ImageService.swift
//  Github
//
//  Created by Ruel Lafuente on 10/2/21.
//

import Foundation
import UIKit

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func getImage(url: URL, completion: @escaping (_ image: UIImage?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(thisUrl: url, completion: completion)
        }
    }
    
    static func downloadImage(thisUrl: URL, completion: @escaping (_ image: UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: thisUrl) {data, url, error in
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: thisUrl.absoluteString as NSString)
            }
            
        }
        
        dataTask.resume()
        
    }
}

