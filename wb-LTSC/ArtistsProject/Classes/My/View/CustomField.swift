//
//  CustomField.swift
//  meishubao
//
//  Created by LWR on 2017/2/23.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

class CustomField: UITextField {

    override func awakeFromNib() {
     
        let isNight = UserDefaults.standard.bool(forKey: APP_NIGHT_MODE)
        if isNight {
            // kvc
            setValue(RGBAColor(98, g: 98, b: 98, a: 1), forKeyPath: "_placeholderLabel.textColor")
            keyboardAppearance = UIKeyboardAppearance.dark
        }else{
            
            keyboardAppearance = UIKeyboardAppearance.default
        }
        
        // leftView
        let rect = CGRect(x: 0, y: 0, width: 5, height: 1)
        leftView = UIView(frame: rect)
        leftViewMode = .always
        
        dk_textColorPicker = DKColorSwiftWithRGB(0x1D1D26, 0x989898)
    }
}
