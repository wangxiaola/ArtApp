//
//  RegisterViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var phoneField: CustomField!
    @IBOutlet weak var authCodeField: CustomField!
    @IBOutlet weak var pwdField: CustomField!
    @IBOutlet weak var confirmField: CustomField!
    
    @IBOutlet weak var codeLab: UILabel!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet var viewTop: NSLayoutConstraint!
    
    @IBOutlet var topMargin: NSLayoutConstraint!
    var count: Int = 60
    
    var timer: Timer!
    
    var token: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        stopCountDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        count = 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
    }
    
    //MARK: - 初始化
    func setup() {
        
        title = "手机注册"
        view.dk_backgroundColorPicker    = DKColorSwiftWithRGB(0xf6f6f6, 0x1c1c1c)
        topView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x222222)
        if isIPhoneX {
            topMargin.constant += 24
        }
    }
    
    //MARK: - 获取验证码
    @IBAction func onGetAuthCodeClick(_ sender: UITapGestureRecognizer) {
        
        guard !(phoneField.text?.isEmpty)! else {
            
            phoneField.becomeFirstResponder()
            return
        }
        
        guard checkPhoneNum() else {
            phoneField.becomeFirstResponder()
            hudTip("手机号有误")
            return
        }
        
        view.endEditing(true)
        
        // 验证码请求
        hudLoading("获取验证码...")
        LLRequestServer.shareInstance().requestUserCaptcha(withType: "signup", mobile: phoneField.text, success: { (reponse, data) in
            self.showSuccess("验证码已发送,注意查收")
            
            self.codeLab.isUserInteractionEnabled = false
            
            // 定时器
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RegisterViewController.changecurrentTitleString), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer, forMode: .commonModes)
            
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                self.stopCountDown()
                return
            }
            let dic = data as! NSDictionary
            self.token = dic["token"] as! String
            }, failure: { (reponse) in

                self.showError(reponse?.msg)
                
            }) { (error) in

                self.showError("获取验证码错误")
        }
    }
    
    func changecurrentTitleString() {
        
        count -= 1
        if count - 1 <= 0 {
            
            stopCountDown()
        }else {
        
            codeLab.text = "\(count) s"
        }
    }
    
    
    /// 计时器停止
    func stopCountDown() {
        
        if timer != nil {
            
            timer.invalidate()
            timer = nil
        }
        
        codeLab.isUserInteractionEnabled = true
        codeLab.text = "获取验证码"
    }
    
    //MARK: - 注册登录
    @IBAction func onRegisterClick() {
        guard !(phoneField.text?.isEmpty)! else {
            phoneField.becomeFirstResponder()
            return
        }
        
        guard checkPhoneNum() else {
            phoneField.becomeFirstResponder()
            hudTip("手机号有误")
            return
        }
        
        guard !(authCodeField.text?.isEmpty)! else {
            authCodeField.becomeFirstResponder()
            return
        }
        
        guard token != "" else {
            hudTip("验证码有误")
            return
        }
        
        guard !(pwdField.text?.isEmpty)! else {
            pwdField.becomeFirstResponder()
            return
        }
        
        guard !(confirmField.text?.isEmpty)! else {
            confirmField.becomeFirstResponder()
            return
        }
        
        guard checkPwd(text: pwdField.text) else {
            pwdField.becomeFirstResponder()
            hudTip("密码有误")
            return
        }
        
        guard checkPwd(text: confirmField.text) else {
            confirmField.becomeFirstResponder()
            hudTip("密码有误")
            return
        }
        
        guard confirmField.text == pwdField.text else {
            hudTip("两次密码不一致")
            confirmField.text = ""
            confirmField.becomeFirstResponder()
            return
        }
        
        view.endEditing(true)
        
        // 注册请求
        hudLoding()
        LLRequestServer.shareInstance().requestRegister(withAccount: phoneField.text, code: authCodeField.text, codeToken:token, password: pwdField.text, success: { (response, data) in
                self.showSuccess("注册成功")
            
                guard let data = data else { // 如果data为nil
                    PrintLog(message: "data 为 nil")
                    return
                }
                    let dic = data as! NSDictionary
                    let user = MSBUser.mj_object(withKeyValues: dic["user"])
            
                    // 存储用户
                    MSBAccount.save(user)
                    // 存储token
                    MSBAccount.saveToken(dic["token"] as! String!)
                // 发出通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGINOUT_SUCCESS"), object: nil)
            
                self.navigationController?.popToRootViewController(animated: true)
            }, failure: { (response) in

                self.showError("注册失败")
            }) { (error) in

                self.showError("注册错误")
        }
    }
    
    //MARK: - 检查手机号
    func checkPhoneNum() -> Bool {
        
        let pred = NSPredicate(format: "SELF MATCHES %@", CHECKPHONENUM)
        return pred.evaluate(with: phoneField.text)
    }
    
    //MARK: - 检查密码
    func checkPwd(text : String?) -> Bool {
        
        let pred = NSPredicate(format: "SELF MATCHES %@", CHECKPWD)
        return pred.evaluate(with: text)
    }
    
    deinit {
        
        stopCountDown()
    }
    
    @IBAction func viewTap(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
}

