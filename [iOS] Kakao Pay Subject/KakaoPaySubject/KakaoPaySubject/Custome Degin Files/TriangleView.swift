//
//  TriangleView.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 11/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import UIKit

@IBDesignable
class TriangleView: UIView {

    @IBInspectable let bezierPath: UIBezierPath = UIBezierPath()
    
    override func draw(_ rect: CGRect) {

        let layerWidth:    CGFloat = layer.frame.width
        let layerHeight:   CGFloat = layer.frame.height
        let shapeLayer:    CAShapeLayer = CAShapeLayer()
        
        bezierPath.move(to: CGPoint(x: 0, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        bezierPath.fill()
        UIColor.white.setFill()
        
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}
