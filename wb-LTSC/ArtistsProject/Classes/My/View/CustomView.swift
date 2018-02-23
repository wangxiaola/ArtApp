//
//  CustomView.swift
//  meishubao
//
//  Created by LWR on 2016/11/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

@IBDesignable class CustomView: UIView {

    @IBInspectable var fillColor: UIColor = UIColor.red
    
    override func draw(_ rect: CGRect) {
        let mask: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
        let shape: CAShapeLayer = CAShapeLayer()
        
        shape.path = mask.cgPath
        shape.fillColor = fillColor.cgColor
        shape.frame = self.bounds
        self.layer.addSublayer(shape)
        
        addSubview(titleLabel)
    }

    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: self.bounds)
        
        titleLabel.textColor = RGBColor(29, g: 29, b: 38)
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textAlignment = .center
        titleLabel.text = "获取验证码"
        titleLabel.isUserInteractionEnabled = true
        
        return titleLabel
    }()
}
