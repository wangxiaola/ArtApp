//
//  LoginViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SDWebImage
//import IQKeyboardManager

@IBDesignable class LoginViewController: BaseViewController {

    @IBOutlet weak var headerImg: UIImageView!   // 头像
    @IBOutlet weak var phoneField: CustomField!  // 手机输入框
    @IBOutlet weak var pwdField: CustomField!    // 密码输入框
    @IBOutlet weak var topView: UIView!          // 顶部V
    @IBOutlet weak var bottomView: UIView!       // 底部V
    @IBOutlet weak var bgViewH: NSLayoutConstraint!
    
    @IBOutlet weak var loginLab: UILabel!        // 登录/注册
    
    @IBOutlet weak var loginBtn: MSBCustomBtn!       // 登录
    
    @IBOutlet weak var headerImgH: NSLayoutConstraint!
    @IBOutlet weak var headerImgW: NSLayoutConstraint!
    @IBOutlet weak var headerImgTop: NSLayoutConstraint!
    @IBOutlet weak var topViewH: NSLayoutConstraint!
    
    var loginSuccess: (() -> ())?
    @IBOutlet weak var qqBtn: UIButton!

    @IBOutlet weak var weChatBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
        
        let manager = IQKeyboardManager.shared()
        manager.isEnabled = true
        manager.shouldResignOnTouchOutside = false
        manager.shouldToolbarUsesTextFieldTintColor = false
        manager.isEnableAutoToolbar = false
    }

    //MARK: - 1.初始化
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "\(LoginViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.title = "登录"
        
        // 设置背景高度
        
        if bgViewH != nil {
//            if isIPhone5 {
//                bgViewH.constant = ScreenH
//            }else {
//                bgViewH.constant = ScreenH - APP_NAVIGATIONBAR_HEIGHT + 1
//            }
            bgViewH.constant = ScreenH - APP_NAVIGATIONBAR_HEIGHT
        }

        // 夜间模式设置
        headerImg.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "people_collection_cell"), nightImage: #imageLiteral(resourceName: "people_collection_cell_dark"))
        
        weChatBtn.dk_setImage(DKImage.picker(withNormalImage: #imageLiteral(resourceName: "login_wechat"), nightImage: #imageLiteral(resourceName: "login_wechat")), for: .normal)
//   
        qqBtn.dk_setImage(DKImage.picker(withNormalImage: #imageLiteral(resourceName: "login_qq"), nightImage: #imageLiteral(resourceName: "login_qq")), for: .normal)

        topView.dk_backgroundColorPicker = cell_backgroundColorPicker
        bottomView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xE6E6E6, 0x222222)
        loginLab.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)

        // 适配
        headerImgH.constant = ScreenW * 100 / 375.0
        headerImgW.constant = ScreenW * 100 / 375.0
        headerImgTop.constant = ScreenW * 40 / 375.0
        topViewH.constant = ScreenW * 220 / 375.0
        
        // 切割头像
        headerImg.layer.cornerRadius = headerImgW.constant / 2.0
        headerImg.layer.masksToBounds = true
    }
    
    //MARK: - 检查手机号
    func checkPhoneNum() -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", CHECKPHONENUM)
        return pred.evaluate(with: phoneField.text)
    }
    
    //MARK: - 检查密码
    func checkPwd() -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", CHECKPWD)
        return pred.evaluate(with: pwdField.text)
    }
    
    //MARK: - 登录
    @IBAction func onLoginClick() {
        guard !(phoneField.text?.isEmpty)! else {
            phoneField.becomeFirstResponder()
            return
        }
        
        guard checkPhoneNum() else {
            phoneField.becomeFirstResponder()
            hudTip("手机号有误")
            return
        }
        
        guard !(pwdField.text?.isEmpty)! else {
            pwdField.becomeFirstResponder()
            return
        }
        
        guard checkPwd() else {
            pwdField.becomeFirstResponder()
            hudTip("密码有误")
            return
        }
        
        view.endEditing(true)
        
        // 登录请求
        hudLoading("登录中...")
        LLRequestServer.shareInstance().requestLogin(withAccount: phoneField.text, password: pwdField.text, success: { (response, data) in
            
                
                guard let data = data else { // 如果data为nil
                    PrintLog(message: "data 为 nil")
                    return
                }
                let dic = data as? NSDictionary
            
                let user = MSBUser.mj_object(withKeyValues: dic?["user"])
                MSBAccount.save(user)
                // 存储token
                MSBAccount.saveToken(dic?["token"] as! String!)
                // 下载头像
                if let img = user?.avatar {
                    
                    SDWebImageManager.shared().loadImage(with: URL.init(string: img), options: .retryFailed, progress: nil, completed: { (image, nil, error, cacheType, finished, imageURl) in
                        self.showSuccess("登录成功")
                        if finished {
                            user?.avarImage = image?.scaled(to: CGSize(width: 320, height: 320))
                            // 存储用户
                            MSBAccount.save(user)
                            self.navigationController?.popViewController(animated: true)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGINOUT_SUCCESS"), object: nil)
                        }else{
                            self.navigationController?.popViewController(animated: true)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGINOUT_SUCCESS"), object: nil)
                        }
                    })

                }
            
                // 回退
            
//                self.loginSuccess?()
            }, failure: { (response) in
                self.showError(response?.msg)
            }) { (error) in
                self.showError("登录错误")
        }
    }
    
    //MARK: - 忘记密码
    @IBAction func onForgetPwdClick() {
        let findPwdVC = FindPwdViewController()
        navigationController?.pushViewController(findPwdVC, animated: true)
    }
    
    //MARK: - 手机注册
    @IBAction func onPhoneRegisterClick() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    //MARK: - 第三方登录
    //MARK: - 微信

    @IBAction func onWeiChatLogin(_ sender: UIButton) {
        PrintLog(message: "onWeiChatLogin")
        self.umSocialSnsPlatform(.wechatSession)
    }
    //MARK: - qq
    @IBAction func onQQLogin(_ sender: UIButton) {
        PrintLog(message: "onQQLogin")
        self.umSocialSnsPlatform(.QQ)
    }

    func umSocialSnsPlatform(_ platform:UMSocialPlatformType){
        UMSocialManager.default().getUserInfo(with: platform, currentViewController: nil) { (result, error) in
            if (error != nil){
                self.showError("信息获取失败")
                PrintLog(message: error?.localizedDescription)
            }else{
                
                let resp:UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
                print(resp.uid)
                var type:Int = 0
                if platform == .wechatSession{
                     type = 2
                }else if platform == .QQ{
                    type = 3
                }
//                else if platform == .sina{
//                    type = 1
//                }
                self.hudLoading("登录中...")
                LLRequestServer.shareInstance().requestThirdOauthLoginWithtUid(resp.uid, type: type, avatar: resp.iconurl, nickname: resp.name, success: { (response, data) in
                
                    guard let data = data else { // 如果data为nil
                        PrintLog(message: "data 为 nil")
                        return
                    }
                    let dic = data as? NSDictionary
                    let user = MSBUser.mj_object(withKeyValues: dic?["user"])
                    MSBAccount.saveToken(dic?["token"] as! String!)
                    MSBAccount.save(user)
                    // 下载头像
                    if let img = user?.avatar {
                        SDWebImageManager.shared().loadImage(with: URL.init(string: img), options: .retryFailed, progress: nil, completed: { (image, nil, error, cacheType, finished, imageURl) in
                            self.showSuccess("登录成功")
                            if finished {
                                user?.avarImage = image?.scaled(to: CGSize(width: 320, height: 320))
                                MSBAccount.save(user)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGINOUT_SUCCESS"), object: nil)
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGINOUT_SUCCESS"), object: nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    
                   
                    // 回退
                    
//                    self.loginSuccess?()
                    }, failure: { (response) in

                        self.showError("登录失败")
                    }, error: { (error) in

                        self.showError("登录失败")
                })
            }
        }
    }
}

extension LoginViewController: UIScrollViewDelegate {
    @IBAction func viewTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    //MARK: - 设置照片选择器导航
    func settingNaviBar(picker: UIImagePickerController) {
        // 设置导航颜色
        picker.navigationBar.setBackgroundImage(UIImage.mm_image(with: APP_TABBARITEM_SELET_COLOR), for: .default)
        
        // 设置字体大小,颜色
        var titleAttDic: [String : NSObject] = Dictionary()
        titleAttDic[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 18)
        titleAttDic[NSForegroundColorAttributeName] = UIColor.white
        picker.navigationBar.titleTextAttributes = titleAttDic
        
        // 设置导航颜色
        picker.navigationBar.setBackgroundImage(UIImage.mm_image(with: APP_TABBARITEM_SELET_COLOR), for: .default)
    }
}


