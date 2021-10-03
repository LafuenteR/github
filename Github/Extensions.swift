//
//  Extensions.swift
//  Github
//
//  Created by Ruel Lafuente on 10/2/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func parseJson(json: Data) -> [User] {
        let decoder = JSONDecoder()
        var users = [User]()
        if let jsonUsers = try? decoder.decode([User].self, from: json) {
            users = jsonUsers
            return users
        }
        return users
    }
}

extension UIImage {
    func invertedImage() -> UIImage {
        let theImage = self
        let filter = CIFilter(name: "CIColorInvert")
        filter!.setValue(CIImage(image: theImage), forKey: kCIInputImageKey)
        let newImage = UIImage(ciImage: (filter?.outputImage!)!)
        return newImage
    }
}

extension Int {
    func divisibleByFour() -> Bool {
        return self % 4 == 0 ? true : false
    }
}
