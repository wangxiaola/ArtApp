//
//  HistoryViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit

class HistoryViewController: BaseViewController {
    
    @IBOutlet weak var topViewH: NSLayoutConstraint! // 顶部"阅读历史"高度
    @IBOutlet weak var tagViewH: NSLayoutConstraint! // 标签视图高度
    @IBOutlet weak var scrollH: NSLayoutConstraint!  // 滚动视图高度
    @IBOutlet weak var tagView: UIView!              // 标签视图
    
    @IBOutlet weak var historyOne: UILabel!
    @IBOutlet weak var historyTwo: UILabel!
    @IBOutlet weak var historyThree: UILabel!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var buttomLab: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    
    
    var bgTap: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1, 初始化
        self.setup()
    }
    
    //MARK: - 初始化
    private func setup() {
        // 设置夜间模式
        view.dk_backgroundColorPicker = cell_backgroundColorPicker
        topView.dk_backgroundColorPicker = cell_backgroundColorPicker
        centerView.dk_backgroundColorPicker = cell_backgroundColorPicker
        bottomView.dk_backgroundColorPicker = cell_backgroundColorPicker
        scroll.dk_backgroundColorPicker = cell_backgroundColorPicker
        line1.dk_backgroundColorPicker = separatorColorPicker
        line2.dk_backgroundColorPicker = separatorColorPicker
        line3.dk_backgroundColorPicker = separatorColorPicker
        line4.dk_backgroundColorPicker = separatorColorPicker
        historyOne.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        historyTwo.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        historyThree.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        buttomLab.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        
        tagView.addSubview(tagList)
        tagList.frame = CGRect(x: 0, y: 0, width: ScreenW - APP_NAVIGATIONBAR_HEIGHT, height: 0)
        
        scrollH.constant = ScreenH - topViewH.constant - APP_NAVIGATIONBAR_HEIGHT
        
        // 显示阅读历史
        getReadHistory()
        
        // 获取近期热点
        loadRecentHot()
    }
    
    //MARK: - 懒加载
    lazy var tagList: YZTagList = {
        let tagList = YZTagList()
        tagList.backgroundColor = UIColor.clear
        tagList.tagListH = 40
        tagList.tagFont = UIFont.systemFont(ofSize: 14)
        tagList.tagButtonMargin = 8
        tagList.borderWidth = 1
        tagList.changeBtnH = true
        //tagList.borderColor = UIColor.colorWithHex(0x989898)
        tagList.borderColor = RGBColor(238, g: 238, b: 238)

        tagList.clickTagBlock = {(tag, index) in
            PrintLog(message: "----\(tag)====\(index)")
            let model = self.tagModelArray[index]
            let vc = MSBArticleDetailController()
            vc.tid = model.post_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return tagList
    }()
    
    // 懒加载
    lazy var dataSource: [MSBHistoryModel] = {
        let dataSource = [MSBHistoryModel]()
        return dataSource
    }()
    
    lazy var tagModelArray: [ArticleModel] = {
        let tagModelArray = [ArticleModel]()
        return tagModelArray
    }()
}

extension HistoryViewController {
    //MARK: - 获取近期热点
    func loadRecentHot() {
        hudLoding()
        LLRequestServer.shareInstance().requestRecentHotSuccess({ (response, data) in
            self.hiddenHudLoding()
            
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
            }
            
            let arr1 = ArticleModel.mj_objectArray(withKeyValuesArray: data)
            guard let arr = arr1 else {
                return
            }
            var tagArr = [String]()
            for model in arr {
                let m = model as! ArticleModel
                tagArr.append(m.post_title)
                self.tagModelArray.append(m)
            }

            self.tagList.addTags(tagArr)
            self.tagViewH.constant = self.tagList.height + 20
            self.scrollH.constant = self.tagViewH.constant + 60
            
            }, failure: { (response) in
                self.hiddenHudLoding()
            }) { (error) in
                self.hiddenHudLoding()
        }
    }
}

//MARK: - 显示阅读历史
extension HistoryViewController {
    @IBAction func bgViewTap(_ sender: UITapGestureRecognizer) {
        bgTap?()
    }
    
    func getReadHistory() {

        let searchArr = dbHelper.search(MSBHistoryModel.self, where: nil, orderBy: "id desc", offset: 0, count: 3)
        
        guard let arr = searchArr  else {
            return
        }
        
        for i in 0..<arr.count {
            let model = arr[i] as! MSBHistoryModel
            if i == 0 {
                historyOne.text = model.title
                dataSource.append(model)
            }else if i == 1 {
                historyTwo.text = model.title
                dataSource.append(model)
            }else {
                historyThree.text = model.title
                dataSource.append(model)
            }
        }
        
        switch arr.count {
        case 0:
            topViewH.constant = 0 // 隐藏阅读历史视图
        case 1:
            topViewH.constant = 81
        case 2:
            topViewH.constant = 113
        case 3:
            topViewH.constant = 153
        default: break
        }
    }
    
    @IBAction func historyOneTap() {
        let model = self.dataSource[0]
        let vc = MSBArticleDetailController()
        vc.tid = model.tid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func historyTwoTap() {
        let model = self.dataSource[1]
        let vc = MSBArticleDetailController()
        vc.tid = model.tid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func historyThreeTap() {
        let model = self.dataSource[2]
        let vc = MSBArticleDetailController()
        vc.tid = model.tid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func moreReadHistory() {
        PrintLog(message: "更多阅读历史")
//        navigationController?.pushViewController(MoreReadHistoryVC(), animated: true)
        navigationController?.pushViewController(MSBHistoryReadController(), animated: true)
    }
}
