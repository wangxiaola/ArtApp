//
//  MyViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SDWebImage
//import LKDBHelper

class MyViewController: BaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 重新获取缓存大小
        if datas.count > 2 {
            let indexPath = IndexPath(row: 2, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _commitInit()
    }
    

    func _commitInit(){
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        
        // 退出登录, ios9 that NSNotificationCenter no longer needs to be cleaned up!
        NotificationCenter.default.addObserver(self, selector: #selector(MyViewController.loginoutSuccess), name: NSNotification.Name(rawValue: "LOGINOUT_SUCCESS"), object: nil)
    }
    
    lazy var datas: [Dictionary<String,String>] = {
        var datas = [Dictionary<String,String>]()
        datas.append(["icon" : "info_setting", "row" : "0", "title":"设置", "identifier":MSBInfoArrowCell.identifier()])
        datas.append(["icon" : "feed_pencil", "row" : "1", "title":"帮助与反馈", "identifier":MSBInfoArrowCell.identifier()])
        datas.append(["icon" : "info_cach", "row" : "2", "title":"清除缓存", "identifier":MSBInfoArrowCell.identifier()])
        datas.append(["icon" : "app_share", "row" : "3", "title":"邀请好友", "identifier":MSBInfoArrowCell.identifier()])
        datas.append(["icon" : "info_about", "row" : "4", "title":"关于我们", "identifier":MSBInfoArrowCell.identifier()])
        return datas
    }()
    
    lazy var headerView: MSBInfoHeaderView = {
        let headerView = MSBInfoHeaderView(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenW * 272 / 375.0))
        headerView.setNicName()
        headerView.delegate = self
        return headerView
    }()
    
    lazy var tableView: UITableView = {
        var tabbarHeight = APP_TABBAR_HEIGHT
        if (isIPhoneX) {
            tabbarHeight += iPhoneXBottomHeight
        }
        let tableView = UITableView(frame: CGRect.init(x: 0, y: APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: ScreenH - APP_NAVIGATIONBAR_HEIGHT - tabbarHeight), style:.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.register(MSBInfoArrowCell.self, forCellReuseIdentifier: MSBInfoArrowCell.identifier())
        tableView.separatorStyle = .none
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xe6e6e6, 0x1c1c1c)
        return tableView
    }()
    
    // 计算缓存大小
    static var cacheSize: String{
        get{
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let fileManager = FileManager.default
            
            func caculateCache() -> Float{
                var total: Float = 0
                if fileManager.fileExists(atPath: basePath!){
                    let childrenPath = fileManager.subpaths(atPath: basePath!)
                    if childrenPath != nil{
                        for path in childrenPath!{
                            let childPath = basePath!.appending("/\(path)")
                            do{
                                let attr = try fileManager.attributesOfItem(atPath: childPath) as NSDictionary
                                let fileSize = attr["NSFileSize"] as! Float
                                total += fileSize
                                
                            }catch _{
                                
                            }
                        }
                    }
                }
                return total
            }
            return NSString(format: "%.2fMB", caculateCache() / 1024.0 / 1024.0 ) as String
        }
    }
}

// //MARK: - UITableViewDataSource, UITableViewDelegate
extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = datas[indexPath.row]["identifier"]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if let arrowCell = cell as? MSBInfoArrowCell{
            arrowCell.itemValue = datas[indexPath.row]
                guard indexPath.row != 2 else {
                    arrowCell.cacheSize = MyViewController.cacheSize
                    return
                }
                guard indexPath.row != 4 else {
                    arrowCell.lineLayer.removeFromSuperlayer()
                    return
                }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var vc: BaseViewController?
        if (indexPath.row == 0){
            vc = MSBSettingController()
        }else if(indexPath.row == 1){
            vc = MSBHelpFeedController()
        }else if(indexPath.row == 3){
            //邀请
            showShareItem()
        }else if(indexPath.row == 4){
            vc = MSBAboutUsController()
        }else{
            clearMemory()
            return
        }

        guard let viewController = vc else {
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func showShareItem() {

        let shareContenView: MSBShareContentView = MSBShareContentView.shareInstance()
        shareContenView.shareTitle(APP_SHARE_TITLE, desc: APP_SHARE_DESC, url: APP_SHARE_URL, img: #imageLiteral(resourceName: "app_logo"))
        shareContenView.articleDetialVC = self
        shareContenView.show()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenW * 52 / 375.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScreenW * 6.6 / 375.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001;
    }
}

//MARK: - MSBInfoHeaderViewDelegate
extension MyViewController: MSBInfoHeaderViewDelegate {
    func loginoutSuccess() {
        headerView.setNicName()
    }
    
    func commentClick() {
        judgeTokenIsEmpty() ? () :
            navigationController?.pushViewController(MSBFollowPosterController(), animated: true)
    }
    
    func historyClick() {
        navigationController?.pushViewController(MSBHistoryReadController(), animated: true)
    }
    
    func storeClick() {
        judgeTokenIsEmpty() ? () :
            navigationController?.pushViewController(MSBCollectController(), animated: true)
    }
    
    func followClick() {
        judgeTokenIsEmpty() ? () :
        navigationController?.pushViewController(MSBFollowController(), animated: true)
    }
    
    func loginClick() {
        let loginVC = LoginViewController()
        loginVC.loginSuccess = {() in
            self.headerView.setNicName()
        }
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // 判断是否已经登录
    func judgeTokenIsEmpty() -> Bool {
        guard !MSBAccount.getToken().isEmpty else {
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: true)
            
            return true
        }
        return false
    }
}

//MARK: - UIActionSheetDelegate
extension MyViewController{
    func clearMemory(){
        let sure = UIAlertAction(title: "确认", style: .destructive) { (action) in
            self.hudLoading("清除中...")
            _ = self.clearCache() // 清除缓存
            self.showSuccess("清除完成")
            let indexPath = IndexPath(row: 2, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let alertVC = UIAlertController(title: "确定删除所有缓存？问答草案、离线内容及图片均会被清除", message: nil, preferredStyle: .actionSheet)
        
        alertVC.addAction(sure)
        alertVC.addAction(cancel)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: -  清除缓存
    func clearCache() -> Bool{
        var result = true
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        
        LKDBHelper.clearTableData(MSBArticleDetailModel.self)

        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/termArr.data")
        if fileManager.fileExists(atPath: filePath!) {
        
            do{
                
                try fileManager.removeItem(atPath: filePath!)
            }catch _{
                
            }
        }
        
        if fileManager.fileExists(atPath: basePath!){
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            for childPath in childrenPath!{
                let cachePath = basePath?.appending("/\(childPath)")
                do{
                    try fileManager.removeItem(atPath: cachePath!)
                }catch _{
                    result = false
                }
            }
        }
        
        return result
    }
}
