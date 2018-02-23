//
//  UIColor-Extention.swift
//  evtmaster
//
//  Created by LWR on 16/9/26.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

extension UIColor {
    class func colorWithHex(_ hex: NSInteger) -> UIColor {
        return RGBColor(((CGFloat)((hex & 0xFF0000) >> 16)), g: ((CGFloat)((hex & 0xFF00) >> 8)), b: ((CGFloat)(hex & 0xFF)))
    }
    
    class func colorWithHexAndAlpha(_ hex: NSInteger, alpha: CGFloat) -> UIColor {
        return RGBAColor(((CGFloat)((hex & 0xFF0000) >> 16)), g: ((CGFloat)(hex & 0xFF00)), b: ((CGFloat)(hex & 0xFF)), a: alpha)
    }
}
