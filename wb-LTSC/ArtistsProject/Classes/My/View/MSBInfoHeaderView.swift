//
//  MSBInfoHeaderView.swift
//  meishubao
//
//  Created by T on 16/11/18.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit

protocol MSBInfoHeaderViewDelegate: NSObjectProtocol {
    func commentClick()
    func storeClick()
    func historyClick()
    func followClick()
    func loginClick()
}

class MSBInfoHeaderView: UIView {
    
    weak var delegate: MSBInfoHeaderViewDelegate?
    override  init(frame: CGRect) {
        super.init(frame: frame)
        dk_backgroundColorPicker = cell_backgroundColorPicker
        _commitInit()
        NotificationCenter.default.addObserver(self, selector: #selector(MSBInfoHeaderView.changeImage(noti:)), name: NSNotification.Name(rawValue:"changeColor"), object: nil)
    }
    
    func changeImage(noti: Notification) {
        
        let night = noti.userInfo?["isNight"]
        let user = MSBAccount.getUser()
        
        if night as! Bool {
            
            if user?.avarImage != nil {
                headerImageView.image = user?.avarImage
                headerImageView.layer.borderWidth = 1
            }else{
                headerImageView.image = #imageLiteral(resourceName: "people_collection_cell_dark")
                headerImageView.layer.borderWidth = 0
            }
        }else {
        
            if user?.avarImage != nil {
                headerImageView.image = user?.avarImage
                headerImageView.layer.borderWidth = 1
            }else{
                headerImageView.image = #imageLiteral(resourceName: "people_collection_cell")
                headerImageView.layer.borderWidth = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // 头像进行切割
        super.layoutSubviews()
        
        headerImageView.layer.cornerRadius = headerImageView.width / 2.0
        headerImageView.layer.masksToBounds = true
    }
    
    private  func _commitInit(){
        addSubview(headerImageView)
        addSubview(nameLab)
        addSubview(descLab)
        addSubview(loginBtn)
        addSubview(commentBtn)
        addSubview(commentBottomLine)
        addSubview(historyBtn)
        addSubview(historyBottomLine)
        addSubview(storeBtn)
        addSubview(storeBottomLine)
        addSubview(followBtn)
        addSubview(followBottomLine)
    
        // 添加约束
        headerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(ScreenW * 38 / 375)
            make.width.height.equalTo(ScreenW * 100 / 375.0)
            make.centerX.equalTo(self)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageView.snp.bottom).offset(ScreenW * 20 / 375.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(18)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageView.snp.bottom).offset(ScreenW * 20 / 375.0)
            make.centerX.equalTo(self)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        descLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom).offset(ScreenW * 6.5 / 375.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(18)
        }
        
        let margin: CGFloat = (ScreenW - 4 * 34) / 5
        commentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.bottom.equalTo(self).offset(-22.5)
            make.width.equalTo(34)
            make.height.equalTo(16)
        }
        
        followBottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(commentBtn)
            make.top.equalTo(commentBtn.snp.bottom).offset(2)
            make.width.equalTo(commentBtn)
            make.height.equalTo(2)
        }
        
        historyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(margin * 2 + 34)
            make.bottom.equalTo(commentBtn.snp.bottom)
            make.width.equalTo(34)
            make.height.equalTo(16)
        }
        
        historyBottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(historyBtn)
            make.top.equalTo(historyBtn.snp.bottom).offset(2)
            make.width.equalTo(historyBtn)
            make.height.equalTo(2)
        }
        
        storeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(margin * 3 + 68)
            make.bottom.equalTo(commentBtn.snp.bottom)
            make.width.equalTo(34)
            make.height.equalTo(16)
        }
        
        storeBottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(storeBtn)
            make.top.equalTo(storeBtn.snp.bottom).offset(2)
            make.width.equalTo(storeBtn)
            make.height.equalTo(2)
        }
        
        followBtn.snp.makeConstraints { (make) in
            make.left.equalTo(margin * 4 + 102)
            make.bottom.equalTo(commentBtn.snp.bottom)
            make.width.equalTo(34)
            make.height.equalTo(16)
        }

        commentBottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(followBtn)
            make.top.equalTo(followBtn.snp.bottom).offset(2)
            make.width.equalTo(followBtn)
            make.height.equalTo(2)
        }
    }
    
    lazy var headerImageView: UIImageView = {
        let header = UIImageView()

        header.contentMode = .scaleAspectFill
        let user = MSBAccount.getUser()
        if user?.avarImage != nil {
            header.image = user?.avarImage
            header.layer.borderWidth = 1
        }else{
            header.layer.borderWidth = 0
            if dk_manager().themeVersion == "NORMAL" {
                
                header.image = #imageLiteral(resourceName: "people_collection_cell")
            }else {
                
                header.image = #imageLiteral(resourceName: "people_collection_cell_dark")
            }
        }
        header.contentMode = .scaleAspectFill
        header.layer.cornerRadius = header.width / 2.0
        header.clipsToBounds =  true
        header.layer.borderWidth = 0
        header.layer.borderColor = RGBColor(181, g: 27, b: 32).cgColor
        return header
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.dk_textColorPicker = DKColorSwiftWithRGB(0x030303, 0x989898)
        nameLab.font = UIFont.boldSystemFont(ofSize: 18)
        nameLab.textAlignment = .center
        nameLab.isHidden = true

        return nameLab
    }()
    
    lazy var descLab: UILabel = {
        let descLab = UILabel()
        descLab.dk_textColorPicker = DKColorSwiftWithRGB(0x7a7a7a, 0x989898)
        descLab.font = UIFont.systemFont(ofSize: 15)
        descLab.textAlignment = .center
        descLab.isHidden = true
        
        return descLab
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setTitle("登录/注册", for: .normal)
//        loginBtn.setTitleColor(UIColor.black, for: .normal)
        loginBtn.dk_setTitleColorPicker(DKColorSwiftWithRGB(0x030303, 0x989898), for: .normal)
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginBtn.addTarget(self, action: Selector!(#selector(MSBInfoHeaderView.didLoginButton)), for: .touchUpInside)
        
        return loginBtn
    }()
    
    lazy var commentBtn: UIButton = {
        let commentBtn = UIButton.init(type: UIButtonType.custom)
        commentBtn.setTitle("跟帖", for: UIControlState.normal)
        commentBtn.dk_setTitleColorPicker(DKColorSwiftWithRGB(0x030303, 0x989898), for: .normal)
        commentBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        commentBtn.titleLabel?.textAlignment = .center
        commentBtn.addTarget(self, action: Selector!(#selector(MSBInfoHeaderView.didCommentButton)), for: .touchUpInside)
        
        return commentBtn
    }()
    
    lazy var historyBtn: UIButton = {
        let historyBtn = UIButton.init(type: UIButtonType.custom)
        historyBtn.setTitle("历史", for: UIControlState.normal)
        historyBtn.dk_setTitleColorPicker(DKColorSwiftWithRGB(0x030303, 0x989898), for: .normal)
        historyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        historyBtn.titleLabel?.textAlignment = .center
        historyBtn.addTarget(self, action: Selector!(#selector(MSBInfoHeaderView.didHistoryButton)), for: .touchUpInside)
        return historyBtn
    }()
    
    lazy var storeBtn: UIButton = {
        let storeBtn = UIButton.init(type: UIButtonType.custom)
        storeBtn.setTitle("收藏", for: UIControlState.normal)
        storeBtn.dk_setTitleColorPicker(DKColorSwiftWithRGB(0x030303, 0x989898), for: .normal)
        storeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        storeBtn.titleLabel?.textAlignment = .center
        storeBtn.addTarget(self, action: Selector!(#selector(MSBInfoHeaderView.didStoreBtn)), for: .touchUpInside)
        return storeBtn
    }()
    
    lazy var followBtn: UIButton = {
        let followBtn = UIButton.init(type: UIButtonType.custom)
        followBtn.setTitle("关注", for: UIControlState.normal)
        followBtn.dk_setTitleColorPicker(DKColorSwiftWithRGB(0x030303, 0x989898), for: .normal)
        followBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        followBtn.titleLabel?.textAlignment = .center
        followBtn.addTarget(self, action: Selector!(#selector(MSBInfoHeaderView.didFollowBtn)), for: .touchUpInside)
        return followBtn
    }()
    
    
    lazy var followBottomLine:UIView = {
        let follow = UIView.init()
        follow.backgroundColor = UIColor.black
        follow.dk_backgroundColorPicker = DKColorSwiftWithRGB(0x030303, 0x989898)
        return follow
    }()
    lazy var storeBottomLine:UIView = {
        let store = UIView.init()
        store.backgroundColor = UIColor.black
        store.dk_backgroundColorPicker = DKColorSwiftWithRGB(0x030303, 0x989898)
        return store
    }()
    lazy var historyBottomLine:UIView = {
        let history = UIView.init()
        history.backgroundColor = UIColor.black
        history.dk_backgroundColorPicker = DKColorSwiftWithRGB(0x030303, 0x989898)
        return history
    }()
    lazy var commentBottomLine:UIView = {
        let comment = UIView.init()
        comment.backgroundColor = UIColor.black
        comment.dk_backgroundColorPicker = DKColorSwiftWithRGB(0x030303, 0x989898)
        return comment
    }()
}

extension MSBInfoHeaderView{
    
    func setNicName() {
        guard !MSBAccount.userLogin() else {
            PrintLog(message: MSBAccount.getToken())
            loginBtn.isHidden = true
            nameLab.isHidden = false
            descLab.isHidden = false
            
            let user = MSBAccount.getUser()
            nameLab.text = user?.nickname ?? user?.mobile
            descLab.text = user?.signature ?? user?.mobile
            if user?.avarImage != nil{
                headerImageView.image = user?.avarImage
                headerImageView.layer.borderWidth = 1
            }else{
                headerImageView.layer.borderWidth = 0
                if dk_manager.themeVersion == "NORMAL" {
                    
                    headerImageView.image = #imageLiteral(resourceName: "people_collection_cell")
                }else {
                
                    headerImageView.image = #imageLiteral(resourceName: "people_collection_cell_dark")
                }
            }
            
            return
        }
        
        loginBtn.isHidden = false
        nameLab.isHidden = true
        descLab.isHidden = true
        
        nameLab.text = ""
        descLab.text = ""
        headerImageView.layer.borderWidth = 0
        headerImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "people_collection_cell"), nightImage: #imageLiteral(resourceName: "people_collection_cell_dark"))
    }
    
    
    func didCommentButton(){
        delegate?.commentClick()
    }
    
    func didHistoryButton(){
        delegate?.historyClick()
    }
    
    func didStoreBtn(){
        delegate?.storeClick()
    }
    
    func didFollowBtn(){
        delegate?.followClick()
    }
    
    func didLoginButton() {
        delegate?.loginClick()
    }
}
