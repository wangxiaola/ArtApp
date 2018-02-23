//
//  HotShowSearchController.swift
//  meishubao
//
//  Created by 胡亚刚 on 2017/4/21.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit
private let reuseIdentifier = "HotShowCell"
class HotShowSearchController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var startLabel: UILabel!
    var endLabel: UILabel!
    let pickerPosition = CGPoint(x:0,y:APP_NAVIGATIONBAR_HEIGHT + 44)
    fileprivate var startTime: String = ""
    fileprivate var endTime: String = ""
    fileprivate var offset: String?
    fileprivate var dateLableTag: Int?
    
    lazy var datePicker: HotShowDatePicker = {
        let dataPicker = HotShowDatePicker()
        
        dataPicker?.returnSelectedDate({[weak self] (dateStr) in
            if self?.dateLableTag == 10086 {
                self?.startLabel.text = dateStr
                self?.startTime = dateStr ?? ""
            }else{
                self?.endLabel.text = dateStr
                self?.endTime = dateStr ?? ""
            }
        })
        
        return dataPicker!
    }()
    
    // 懒加载
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackItem()
        setLogoTitle()
        view.addSubview(searchbarView)
        searchbarView.addSubview(searchBtn)
        
        view.addSubview(collectionView)
    }

    func addBackItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "navigation_back"), style: .plain, target: self, action: #selector(back))
    }
    
    lazy var collectionView: UICollectionView = {
        
        let itemWidth: CGFloat = (ScreenW - 4 * 15) / 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: HotShowCellHeight)
       
        let collectionView = UICollectionView.init(frame: CGRect(x: 0,y: self.searchbarView.frame.maxY,width: ScreenW,height: ScreenH - APP_NAVIGATIONBAR_HEIGHT -  44), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xf7f7f7, 0x1c1c1c)
        collectionView.register(HotestShowCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // 添加刷新控件
        collectionView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(HotShowSearchController.appendData))
        
        return collectionView
    }()
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HotestShowCell
        cell.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xf7f7f7, 0x1c1c1c)
        cell.showModel = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = MSBArticleDetailController()
        vc.tid = model.post_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func back() {
        self.dismiss(animated: false, completion: nil)
    }
    
    lazy var searchbarView: UIView = {
        
        let dateLabelWidth: CGFloat = (ScreenW - 110) / 2
        
        let searchBarView = UIView.init(frame: CGRect(x: 0,y: APP_NAVIGATIONBAR_HEIGHT,width: ScreenW,height: 44))
        searchBarView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff,0x1c1c1c)
        
        let label1 = UILabel.init(frame: CGRect(x: 15,y: 0,width: 15,height: searchBarView.height))
        label1.font = UIFont.systemFont(ofSize: 12)
        label1.text = "从"
        label1.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        label1.textAlignment = .center
        searchBarView.addSubview(label1)
        
        let startDateLabel = UILabel.init(frame: CGRect(x: label1.frame.maxX + 5,y: 5,width: dateLabelWidth,height: 34))
        startDateLabel.text = self.getCurrentDate()
        self.startTime = startDateLabel.text ?? ""
        startDateLabel.font = UIFont.systemFont(ofSize: 12)
        startDateLabel.isUserInteractionEnabled = true
        startDateLabel.layer.borderWidth = 0.5
        startDateLabel.layer.dk_borderColorPicker = separatorColorPicker
        startDateLabel.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        startDateLabel.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        startDateLabel.textAlignment = .center
        searchBarView.addSubview(startDateLabel)
        self.startLabel = startDateLabel
        
        let startTap = UITapGestureRecognizer.init(target: self, action: #selector(seleStartDate))
        startDateLabel.addGestureRecognizer(startTap)
        
        let label2 = UILabel.init(frame: CGRect(x: startDateLabel.frame.maxX + 5,y: 0,width: 15,height: searchBarView.height))
        label2.font = UIFont.systemFont(ofSize: 12)
        label2.text = "至"
        label2.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        label2.textAlignment = .center
        searchBarView.addSubview(label2)
        
        let endDateLabel = UILabel.init(frame: CGRect(x: label2.frame.maxX + 5,y: startDateLabel.y,width: dateLabelWidth,height: startDateLabel.height))
        endDateLabel.text = self.getCurrentDate()
        self.endTime = endDateLabel.text ?? ""
        endDateLabel.font = UIFont.systemFont(ofSize: 12)
        endDateLabel.isUserInteractionEnabled = true
        endDateLabel.layer.borderWidth = 0.5
        endDateLabel.layer.dk_borderColorPicker = separatorColorPicker
        endDateLabel.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        endDateLabel.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        endDateLabel.textAlignment = .center
        searchBarView.addSubview(endDateLabel)
        self.endLabel = endDateLabel
        
        let endTap = UITapGestureRecognizer.init(target: self, action: #selector(seleEndDate))
        endDateLabel.addGestureRecognizer(endTap)
        
        return searchBarView
    }()
    
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.dk_setImage(DKImage.picker(with: [#imageLiteral(resourceName: "category_search"),#imageLiteral(resourceName: "category_search_dark"),#imageLiteral(resourceName: "category_search")]), for: .normal)
        searchBtn.frame = CGRect(x: ScreenW - 50,y: 0,width: 40,height: 44)
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        return searchBtn
    }()
    
    func seleStartDate() {
        dateLableTag = 10086
        datePicker.showDatePicker(Date(), position: pickerPosition)
    }
    
    func seleEndDate() {
        dateLableTag = 10010
        datePicker.showDatePicker(Date(), position: pickerPosition)
    }
    
    func searchClick() {
        if startTime != "" && endTime != "" {
            dataSource.removeAll()
            collectionView.reloadData()
           requestData(startTime: startTime, endTime: endTime)
        }else {
           hudTip("请选择日期")
           return
        }
    }
    
    func getCurrentDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.string(from: Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: - MJRefresh 网络请求
extension HotShowSearchController {
    func requestData(startTime: String,endTime: String) {
        hudLoding()
        LLRequestServer.shareInstance().requestHotestShow(withOffset: "0", pagesize: 30, startTime: startTime, endTime: endTime, success: { (response, data) in
            self.hiddenHudLoding()
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
            }
            
            if data is String {
                return
            }
            
            let jsonData = data as! NSDictionary
            let arr = ArticleModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
            
            guard arr != nil else { // 如果arr为nil
                return
            }
            
            if (arr?.count)! > 0 {
                self.dataSource.removeAll()
            }
            
            for model in arr! {
                self.dataSource.append(model as! ArticleModel)
            }
            
            self.offset = jsonData["offset"] as? String
            
            self.collectionView.reloadData()
        }, failure: { (response) in
            self.hiddenHudLoding()
        }) { (error) in
            self.hiddenHudLoding()
        }
    }
    
    func appendData() {
        
        LLRequestServer.shareInstance().requestHotestShow(withOffset: self.offset, pagesize: 30, startTime: startTime, endTime: endTime, success: { (response, data) in
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                self.collectionView.mj_footer.resetNoMoreData()
                return
            }
            
            if data is String {
                
                self.collectionView.mj_footer.resetNoMoreData()
                return
            }
            
            let jsonData = data as! NSDictionary
            let arr = ArticleModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
            if (arr?.count)! > 0 {
                for model in arr! {
                    self.dataSource.append(model as! ArticleModel)
                }
            }
            self.offset = jsonData["offset"] as? String
            
            self.collectionView.reloadData()
            self.collectionView.mj_footer.endRefreshing()
        }, failure: { (response) in
            self.collectionView.mj_footer.endRefreshing()
        }) { (error) in
            self.collectionView.mj_footer.endRefreshing()
        }
    }
}
