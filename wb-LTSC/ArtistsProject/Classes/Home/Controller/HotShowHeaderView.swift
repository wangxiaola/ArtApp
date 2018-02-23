//
//  HotShowHeaderView.swift
//  meishubao
//
//  Created by 胡亚刚 on 2017/4/18.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

class HotShowHeaderView: UICollectionReusableView,SDCycleScrollViewDelegate {
    
    var frameChanged: (() ->Void)?
    var searchAction: (() ->Void)?
    var startLabel: UILabel!
    var endLabel: UILabel!
    var images:[SDCycleModel]!
    var vc: UIViewController!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cycleScrollView)
        addSubview(searchbarView)
        searchbarView.addSubview(searchBtn)
        
        let line: CALayer = CALayer()
        line.frame = CGRect(x: 0,y: self.height - 0.5,width: self.width,height: 0.5)
        line.dk_backgroundColorPicker = separatorColorPicker
        layer.addSublayer(line)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var cycleScrollView: SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: self.height - 44), delegate: self, placeholderImage: #imageLiteral(resourceName: "sd_scroll_bg"))
        cycleScrollView?.titleLabelBackgroundColor = RGBAColor(0,g:0,b: 0,a: 0.5)
        cycleScrollView?.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView?.bannerImageViewContentMode = .scaleAspectFill
        return cycleScrollView!
    }()
    
    lazy var searchbarView: UIView = {
        
        let dateLabelWidth: CGFloat = (ScreenW - 110) / 2
        
        let searchBarView = UIView.init(frame: CGRect(x: 0,y: self.cycleScrollView.frame.maxY,width: ScreenW,height: 44))
        searchBarView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xf7f7f7,0x1c1c1c)
        
        let label1 = UILabel.init(frame: CGRect(x: 15,y: 0,width: 15,height: searchBarView.height))
        label1.font = UIFont.systemFont(ofSize: 12)
        label1.text = "从"
        label1.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        label1.textAlignment = .center
        searchBarView.addSubview(label1)
        
        let startDateLabel = UILabel.init(frame: CGRect(x: label1.frame.maxX + 5,y: 5,width: dateLabelWidth,height: 34))
        startDateLabel.font = UIFont.systemFont(ofSize: 12)
        startDateLabel.isUserInteractionEnabled = true
        startDateLabel.layer.borderWidth = 0.5
        startDateLabel.layer.dk_borderColorPicker = separatorColorPicker
        startDateLabel.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        startDateLabel.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        startDateLabel.textAlignment = .center
        searchBarView.addSubview(startDateLabel)
        self.startLabel = startDateLabel
        
        let startTap = UITapGestureRecognizer.init(target: self, action: #selector(toSearchVc))
        startDateLabel.addGestureRecognizer(startTap)
        
        let label2 = UILabel.init(frame: CGRect(x: startDateLabel.frame.maxX + 5,y: 0,width: 15,height: searchBarView.height))
        label2.font = UIFont.systemFont(ofSize: 12)
        label2.text = "至"
        label2.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        label2.textAlignment = .center
        searchBarView.addSubview(label2)
        
        let endDateLabel = UILabel.init(frame: CGRect(x: label2.frame.maxX + 5,y: startDateLabel.y,width: dateLabelWidth,height: startDateLabel.height))
        endDateLabel.font = UIFont.systemFont(ofSize: 12)
        endDateLabel.isUserInteractionEnabled = true
        endDateLabel.layer.borderWidth = 0.5
        endDateLabel.layer.dk_borderColorPicker = separatorColorPicker
        endDateLabel.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        endDateLabel.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        endDateLabel.textAlignment = .center
        searchBarView.addSubview(endDateLabel)
        self.endLabel = endDateLabel
        
        let endTap = UITapGestureRecognizer.init(target: self, action: #selector(toSearchVc))
        endDateLabel.addGestureRecognizer(endTap)
        
        return searchBarView
    }()
    
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.dk_setImage(DKImage.picker(with: [#imageLiteral(resourceName: "category_search"),#imageLiteral(resourceName: "category_search_dark"),#imageLiteral(resourceName: "category_search")]), for: .normal)
        searchBtn.frame = CGRect(x: ScreenW - 50,y: 0,width: 40,height: 44)
        searchBtn.addTarget(self, action: #selector(toSearchVc), for: .touchUpInside)
        return searchBtn
    }()
    
    func toSearchVc() {
        if frameChanged != nil {
            frameChanged!()
        }
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let model = images[index]
        if model.type.integerValue == SDCycleImageTypeUrl {
            if !model.url.isEmpty {
                let webVc = MSBWebBaseController()
                webVc.webUrl = model.url;
                webVc.isWeb = true
                self.vc.navigationController?.pushViewController(webVc, animated: true)
            }
        }else if model.type.integerValue == SDCycleImageTypeArticle{
            if !model.tid.isEmpty {
                let vc = MSBArticleDetailController()
                vc.tid = model.tid;
                self.vc.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
        }
    }
}
