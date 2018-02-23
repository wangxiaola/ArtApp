//
//  CustomBtn.swift
//  meishubao
//
//  Created by LWR on 2016/11/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class CustomBtn: UIButton {    
    
    override func awakeFromNib() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        self.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xB51B20, 0x6f141a)
        self.dk_setTitleColorPicker(DKColorSwiftWithRGB(0xffffff, 0x989898), for: .normal)
    }
}
