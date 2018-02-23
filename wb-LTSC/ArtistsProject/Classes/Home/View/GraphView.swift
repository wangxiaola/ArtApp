//
//  GraphView.swift
//  meishubao
//
//  Created by LWR on 2016/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class GraphView: UIView {
    @IBInspectable var startColor = UIColor.red
    @IBInspectable var endColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        // 获取当前的上下文,绘制一个渐变
        let context = UIGraphicsGetCurrentContext()
        
        // 渐变数组
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 设置渐变色, 各个颜色的渐变范围
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        // darw the gradient 
        let startpoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context!.drawLinearGradient(gradient!, start: startpoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
    }
}
