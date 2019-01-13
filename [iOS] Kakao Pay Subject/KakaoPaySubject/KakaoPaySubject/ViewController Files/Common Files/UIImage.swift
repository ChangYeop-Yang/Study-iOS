//
//  UIImage.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 13/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func downloadImage(link: String) {
        
        DispatchQueue.main.async {
            
            guard let url: URL = URL(string: link) else {
                fatalError("❌ Error, could not connect image from server.")
            }

            Alamofire.request(url).responseData { response in
                guard let imageData: Data = response.data else {
                    fatalError("❌ Error, could not download image from server.")
                }
                self.image                = UIImage(data: imageData)
            }
        }
    }
}
