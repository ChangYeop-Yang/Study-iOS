//
//  DetailTableViewCell.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 11/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import UIKit
import Alamofire

class DetailCell: UICollectionViewCell {
    
    // MARK: - Outlet Variables
    @IBOutlet private weak var tourIMG: UIImageView!
    @IBOutlet private weak var tourNameLB: UILabel!
    @IBOutlet private weak var tourSummaryLB: UILabel!
    @IBOutlet private weak var tourKeywordLB: UILabel!
    
    // MARK: - Method
    public func settingTourInformation(name: String, summary: String, keyword: String, image: String) {
        
        DispatchQueue.main.async { [unowned self] in
            self.tourNameLB.text          = name
            self.tourSummaryLB.text       = summary
            self.tourKeywordLB.text       = keyword
            
            guard let url: URL = URL(string: image) else {
                fatalError("❌ Error, could not connect image from server.")
            }
            Alamofire.request(url).responseData { response in
                
                guard let imageData: Data = response.data else {
                    fatalError("❌ Error, could not download image from server.")
                }
                self.tourIMG.image        = UIImage(data: imageData)
            }
        }
    }
    
    // MARK - Action Method
    @IBAction func showDetailAlert(_ sender: UIButton) {
    }
}
