//
//  MSBInfoArrowCell.swift
//  meishubao
//
//  Created by T on 16/11/18.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class MSBInfoArrowCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.dk_backgroundColorPicker = cell_backgroundColorPicker
        //backgroundColor = UIColor.clear
        //self.selectionStyle = .none
        let seleView: UIView = UIView()
        seleView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xececec, 0x1a1a1a)
        self.selectedBackgroundView = seleView
        _commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _commitInit(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(arrowImageView)
        contentView.layer.addSublayer(lineLayer)
        contentView.addSubview(cacheSizeLab)
    }
    
    var itemValue: Dictionary<String, String>?{
        didSet{
            titleLabel.text = itemValue?["title"]
            guard let row = itemValue?["row"] else {
                return
            }
            
            switch row {
            case "0":
                iconImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "info_setting"), nightImage: #imageLiteral(resourceName: "info_setting_dark"))
            case "1":
                iconImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "feed_pencil"), nightImage: #imageLiteral(resourceName: "feed_pencil_dark"))
            case "2":
                iconImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "info_cach"), nightImage: #imageLiteral(resourceName: "info_cach_dark"))
            case "3":
                iconImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "app_share"), nightImage: #imageLiteral(resourceName: "app_share_dark"))
            default:
                iconImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "info_about"), nightImage: #imageLiteral(resourceName: "info_about_dark"))
            }
        }
    }
    
    var cacheSize: String? {
        didSet {
            arrowImageView.isHidden = true
            cacheSizeLab.isHidden = false
            cacheSizeLab.text = cacheSize
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.dk_textColorPicker = DKColorSwiftWithRGB(0x4a4a4a, 0x989898)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Title"
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .center
        return iconImageView
    }()
    
    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.contentMode = .center
        arrowImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "info_arrow")
            , nightImage:#imageLiteral(resourceName: "info_arrow_dark"))
        return arrowImageView
    }()
    
    lazy var lineLayer: CALayer = {
        let line = CALayer()
        line.dk_backgroundColorPicker = separatorColorPicker
        return line
    }()
    
    lazy var cacheSizeLab: UILabel = {
        let cacheSizeLab = UILabel()
        cacheSizeLab.dk_textColorPicker = DKColorSwiftWithRGB(0x4a4a4a, 0xD8787D)
        cacheSizeLab.font = UIFont.systemFont(ofSize: 14)
        cacheSizeLab.isHidden = true
        cacheSizeLab.textAlignment = .right
        
        return cacheSizeLab
    }()
}

extension MSBInfoArrowCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect.init(x: ScreenW * 15.2 / 375.0, y: 0, width: 22, height: rowHeight())
        
        titleLabel.frame = CGRect.init(x: iconImageView.frame.maxX + 14.6, y: 0, width: 100, height: rowHeight())
        
        arrowImageView.frame = CGRect.init(x: ScreenW - 20, y: 0, width: 10, height: rowHeight())
        
        lineLayer.frame = CGRect.init(x: ScreenW * 44 / 375.0, y: rowHeight() - 0.5, width: ScreenW - (ScreenW * 44 / 375.0), height: 0.5)
        
        cacheSizeLab.frame = CGRect(x: ScreenW - 158, y: 0, width: 150, height: rowHeight())
    }
    
    func rowHeight() -> CGFloat {
        
        return ScreenW * 52 / 375.0
    }
    
}
