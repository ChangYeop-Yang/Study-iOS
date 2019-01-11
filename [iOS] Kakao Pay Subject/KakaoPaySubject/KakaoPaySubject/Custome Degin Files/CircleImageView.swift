//
//  CircleImageView.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 9. 1..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImageView: UIImageView {
    
    override func layoutSubviews() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
