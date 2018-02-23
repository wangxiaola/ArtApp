//
//  FindPwdViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class FindPwdViewController: BaseViewController {
    
    
    @IBOutlet weak var phoneField: CustomField!
    @IBOutlet weak var authCodeField: CustomField!
    @IBOutlet weak var pwdField: CustomField!
    @IBOutlet weak var confirmField: CustomField!
    
    @IBOutlet weak var codeLab: UILabel!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var sureBtn: MSBCustomBtn!
    
    @IBOutlet var topViewTop: NSLayoutConstraint!

    var verifyCodeToken :String = " "
    
    var count: Int = 60
    
    var timer: Timer!
    
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
    
    //MARK: - 1.初始化
    func setup() {
        title = "找回密码"
        view.dk_backgroundColorPicker    = DKColorSwiftWithRGB(0xf6f6f6, 0x1c1c1c)
        topView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x222222)
        if isIPhoneX {
            topViewTop.constant += 24
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
        
        // 获取验证码
        hudLoading("获取验证码...")
        LLRequestServer.shareInstance().requestUserCaptcha(withType: "retrievepassword", mobile: phoneField.text, success: { (response, data) in
            
            self.codeLab.isUserInteractionEnabled = false
            
            // 定时器
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RegisterViewController.changecurrentTitleString), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer, forMode: .commonModes)
            
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                self.stopCountDown()
                return
            }
            self.showSuccess("验证码已发送,注意查收")
            let dic = data as! NSDictionary
            self.verifyCodeToken = dic["token"] as! String
            //print("token == \(self.verifyCodeToken)")
            
            }, failure: { (response) in
                self.showError(response?.msg)
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
    
    //MARK: - 完成
    @IBAction func completeClick() {
        guard !(phoneField.text?.isEmpty)! else {
            phoneField.becomeFirstResponder()
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
        
        guard checkPhoneNum() else {
            phoneField.becomeFirstResponder()
            hudTip("手机号有误")
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
        self.hudLoding();
        
        LLRequestServer.shareInstance().requestUserRetrievepass(withVerifyCodeToken: self.verifyCodeToken, mobile: phoneField.text, password: pwdField.text, code: authCodeField.text, success: { (response, data) in
            self.showSuccess("密码修改成功")
             self.navigationController?.popViewController(animated: true)
            }, failure: { (response) in
                self.showError("密码修改失败")
            }) { (error) in
                self.showError("密码修改失败")
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
