//
//  SortViewController.swift
//  meishubao
//
//  Created by LWR on 2017/4/19.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

typealias toSort = ([ArticleCategoryModel]) -> Void

class SortViewController: BaseViewController {

    var backSort : toSort?
    fileprivate var tagList : YZTagList!
    var dataArr = [ArticleCategoryModel]()
    fileprivate var titileDic = [String : ArticleCategoryModel]()
    
    override func viewWillDisappear(_ animated: Bool) {
    
        super.viewWillDisappear(animated)
        guard tagList.hasMove else {
            
            return
        }
        
        guard backSort != nil else {
            
            return
        }
        dataArr.removeAll()
        var termList = [[String : String]]()
        for title in tagList.tagArray {

            let model = titileDic[title as! String]
            dataArr.append(model!)
            let dic = ["term_id" : model!.term_id, "name" : model!.name]
            termList.append(dic)
        }
        self.backSort!(dataArr)
        
        if MSBAccount.userLogin() {
            
            LLRequestServer.shareInstance().requestPersonalityCategory(termList, success: { (response, data) in
                
                PrintLog(message: "定制分类成功")
            }, failure: { (response) in
                
                PrintLog(message: response?.msg)
            }) { (error) in
                
                PrintLog(message: "定制分类错误")
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
        setTagTitle()
    }
    
    func setup() {
    
        let alertLab                      = UILabel(frame: CGRect(x: 0, y: APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: 40))
        alertLab.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xE8E8E8, 0x202020)
        alertLab.dk_textColorPicker       = DKColorSwiftWithRGB(0x7E7E7E, 0x989898)
        alertLab.font                     = UIFont.systemFont(ofSize: 12)
        alertLab.text                     = "长按拖动改变顺序"
        alertLab.textAlignment            = .center
        view.addSubview(alertLab)
        
        tagList = YZTagList()
        tagList.frame           = CGRect(x: 0, y: APP_NAVIGATIONBAR_HEIGHT + alertLab.height, width: ScreenW, height: 500)
        tagList.tagFont         = UIFont.systemFont(ofSize: 12)
        tagList.tagCornerRadius = 14
        var tagW = 75.0
        if isIPhone5 {
            
            tagW = 72.0
            tagList.tagMargin = 5
        }
        tagList.tagSize         = CGSize(width: tagW, height: 20)
        tagList.scaleTagInSort  = 1.3;
        // 需要排序
        tagList.isSort          = true;
        
        let isNight = UserDefaults.standard.bool(forKey: APP_NIGHT_MODE)
        if isNight {
            
            tagList.tagBackgroundColor = RGBColor(108, g: 108, b: 108)
        }else{
            
            tagList.tagBackgroundColor = RGBColor(223, g: 223, b: 223)
        }
        tagList.changeBtnH       = false
        tagList.changeBtnBGColor = true
        tagList.isFitTagListH    = false
        view.addSubview(tagList)
    }
    
    func setTagTitle() {
    
        var titles = [String]()
        for i in 0..<dataArr.count {
            
            let model = dataArr[i]
            titles.append(model.name)
            titileDic[model.name] = model
        }
        tagList.addTags(titles)
    }
}

