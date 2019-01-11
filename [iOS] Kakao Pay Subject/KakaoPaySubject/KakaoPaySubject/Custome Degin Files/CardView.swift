//
//  CardView.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 6..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius:        CGFloat = 3
    @IBInspectable var shadowOffsetWidth:   Int     = 0
    @IBInspectable var shadowOffsetHeight:  Int     = 3
    @IBInspectable var shadowColor:         UIColor = .black
    @IBInspectable var shadowOpacity:       Float   = 0.3
    
    override func layoutSubviews() {
        layer.cornerRadius  = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor   = shadowColor.cgColor
        layer.shadowOffset  = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath    = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
}
