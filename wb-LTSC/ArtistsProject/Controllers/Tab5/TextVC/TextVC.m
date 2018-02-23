//
//  UserNameVC.m
//  Car
//
//  Created by XICHUNZHAO on 15/9/6.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//
#import "ResultModel.h"
#import "TextVC.h"

@interface TextVC ()

@end

@implementation TextVC

@synthesize txtFieldName,txtView,lblTip,btnCommit;//输入框控件名称
@synthesize fieldName;//如果是保存数据，这里输入保存的数据库字段名称
@synthesize fieldValue;//字段值
@synthesize classid;
@synthesize saveTips;//保存提示文字，如果不填，默认为正在保存数据，请稍候...
@synthesize placeholder;//输入框默认提示值
@synthesize checkType;//检查类型 1.检查是否为空 2.检查手机号码
@synthesize checkTips;//为空的提醒
@synthesize navTitle;//标题
@synthesize maxLength;//输入框输入最大长度
@synthesize keyboardType;//键盘类型
@synthesize isBack;//只是返回输入数据，不保存到数据库
@synthesize moduleName;//模块名 例如TUser
@synthesize actionName;//操作名 例如updateUserInfo
@synthesize tableID;// 表的主键默认为 id
@synthesize isMultiLine;// 多行
@synthesize txtHeight;//控件高度
@synthesize SortName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    checkType=0;
    
    if (!keyboardType) {
        keyboardType = UIKeyboardTypeDefault ;
    }
    if (!saveTips) {
        saveTips = @"正在保存数据，请稍候...";
    }
//    if (checkType) {
//        checkType = 1;
//    }
    
    //NSLog(@"actionName:%@",actionName);
    
    if (!tableID) {
        tableID = @"id";
    }
    if (!checkTips) {
        checkTips = @"数据不能为空";
    }
    self.navigationItem.title=navTitle;
    
    if (isMultiLine) {
        if (![fieldValue isEqualToString:@""]) {
            txtView.text=fieldValue;
            if (txtView.text.length == 0) {
                lblTip.text = placeholder;
            }else{
                lblTip.text = @"";
            }
        }
    }
    else
    {
        txtFieldName.placeholder = placeholder;
        txtFieldName.text=fieldValue;
        
        txtFieldName.clearButtonMode=UITextFieldViewModeWhileEditing;
        
        txtFieldName.delegate = self;
        txtFieldName.tag = 1;
        txtFieldName.returnKeyType = UIReturnKeyDone;
        [txtFieldName setKeyboardType:keyboardType];
    }
    
    
    UIBarButtonItem * RightBarButton=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btnSave)];
    self.navigationItem.rightBarButtonItem=RightBarButton;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isMultiLine) {
        [txtView  becomeFirstResponder];
    }
    else{
        [txtFieldName becomeFirstResponder];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initView
{
    UIScrollView *scrollView=[UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    scrollView.alwaysBounceVertical=YES;
    scrollView.scrollEnabled=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    //scrollView.layer.borderColor=[UIColor redColor].CGColor;
    //scrollView.layer.borderWidth=1;
    
    UIView *content=[UIView new];
    content.userInteractionEnabled = YES;
    [scrollView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    if (!txtHeight) {
        if (isMultiLine) {
            txtHeight = 150;
        }
        else
        {
            txtHeight = 35;
        }
    }
    if (isMultiLine) {
        #pragma mark 输入框
        txtView=[[DDHTextView alloc] init];
        txtView.layer.borderWidth=1.0;
        txtView.translatesAutoresizingMaskIntoConstraints = NO;
        txtView.allowsEditingTextAttributes=YES;
        txtView.layer.borderColor=kLineColor.CGColor;
        txtView.hidden=NO;
        txtView.editable = YES;
        txtView.delegate=self;
        [content addSubview:txtView];

        [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(content);
            make.top.equalTo(content).offset(0);
            make.height.mas_equalTo(SCREEN_HEIGHT-84);
        }];
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(txtView);
        [content addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[txtView]|" options:0 metrics:nil views:viewsDictionary]];
        [content addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[txtView(200)]" options:0 metrics:nil views:viewsDictionary]];
        
        //提示文字
        lblTip=[[UILabel alloc] init];
        lblTip.text=placeholder;
        lblTip.font=[UIFont systemFontOfSize:14];
        lblTip.textColor=[UIColor colorWithHexString:@"#d9d9d9"];
        lblTip.enabled=NO;
        
        [content addSubview:lblTip];
        [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.equalTo(txtView).offset(5);
            make.height.mas_equalTo(20);
        }];
    
        #pragma mark 确认按钮
//        btnCommit=[[UIButton alloc] init];
//        btnCommit.backgroundColor=kBlueColor;
//        btnCommit.layer.cornerRadius=3.0;
//        btnCommit.titleLabel.font=[UIFont systemFontOfSize:15];
//        [btnCommit setTitle:@"确认提交" forState:UIControlStateNormal];
//        [content addSubview:btnCommit];
//        [btnCommit mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(content).offset(20);
//            make.right.equalTo(content).offset(-20);
//            make.top.equalTo(txtView.mas_bottom).offset(30);
//            make.height.mas_equalTo(40);
//        }];
//        
//         [btnCommit addTarget:self action:@selector(btnSave) forControlEvents:UIControlEventTouchUpInside];
        

    }
    else
    {
        txtFieldName = [[HTextField alloc] init];
        txtFieldName.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        txtFieldName.textEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        [content addSubview:txtFieldName];
        [txtFieldName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(content);
            make.top.equalTo(content).offset(30);
            make.height.mas_equalTo(txtHeight);
        }];
        txtFieldName.borderColor=kLineColor;
        txtFieldName.borderWidth=HViewBorderWidthMake(1,0,1,0);
        
        HLabel *lblTip2=[HLabel new];
        [content addSubview:lblTip2];
        [lblTip2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content).offset(10);
            make.top.equalTo(txtFieldName.mas_bottom).offset(10);
        }];
        lblTip2.font=[[Global sharedInstance] fontWithSize:14];
        lblTip2.textColor=ColorHex(@"999999");
        lblTip2.text=@"注：暂不支持表情符号";
        lblTip2.hidden=YES;
    }
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(content.subviews.lastObject);
    }];
    
    //注册键盘出现的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    

    
}

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    //键盘高度
 
    
}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    
    
}




/**
 *  保存事件
 */
-(void)btnSave{
    
    NSString *value;//获取新值

    if (isMultiLine) {
        [txtView  resignFirstResponder];
        value = txtView.text;
    }
    else{
        [txtFieldName resignFirstResponder];
        value = txtFieldName.text;
    }
    
    switch (checkType) {
        case 1:
            if ([value isEqualToString:@""]){
                [self showErrorHUDWithTitle:checkTips SubTitle:nil Complete:^{
                    if (isMultiLine) {
                        [txtView becomeFirstResponder];
                    }
                    else{
                        [txtFieldName becomeFirstResponder];
                    }
                    
                }];
                return;
            }
            break;
        case 2:
            if (value.checkPhoneNumSimple==NO) {
                [self showErrorHUDWithTitle:checkTips SubTitle:nil Complete:^{
                    if (isMultiLine) {
                        [txtView becomeFirstResponder];
                    }
                    else{
                        [txtFieldName becomeFirstResponder];
                    }
                }];
                return;
            }
            break;
            
        default:
            break;
    }
    
    if (!maxLength) {
        maxLength=0;
    }
    if ([value length]>maxLength && maxLength>0) {
        //@"长度不能超过%d字符"
        [self showErrorHUDWithTitle:[NSString stringWithFormat:@"长度不能超过%ld字符",(long)maxLength] SubTitle:nil Complete:^{
        
            if (isMultiLine) {
                [txtView becomeFirstResponder];
            }
            else{
                [txtFieldName becomeFirstResponder];
            }
        }];
        return;

    }
    if (isBack) {
        _saveBtnCilck(value);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else{
        
        if ([value isEqualToString:fieldValue]==YES) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if(_saveBtnCilck){
            _saveBtnCilck(value);
        }
        
//        NSDictionary *dicAll=@{@"uid":[Global sharedInstance].userID,
//                               @"nickname":[Global sharedInstance].userInfo.nickname?:@"",
//                               @"sex":[Global sharedInstance].userInfo.sex?:@"",
//                               @"birth":[Global sharedInstance].userInfo.birth?:@"",
//                               @"province":[Global sharedInstance].userInfo.province?:@"",
//                               @"city":[Global sharedInstance].userInfo.city?:@"",
//                               @"area":[Global sharedInstance].userInfo.area?:@"",
//                               @"location":[Global sharedInstance].userInfo.location?:@"",
//                               @"tag":[Global sharedInstance].userInfo.tag?:@"",
//                               @"auth":[Global sharedInstance].userInfo.auth?:@"",
//                               @"intro":[Global sharedInstance].userInfo.intro?:@"",
//                               @"photo":[Global sharedInstance].userInfo.photo?:@"",
//                               @"audio":[Global sharedInstance].userInfo.audio?:@"",
//                               @"video":[Global sharedInstance].userInfo.video?:@""} ;
//        
//        NSMutableDictionary *dict = [dicAll mutableCopy];
//        [dict setObject:[Global sharedInstance].userID forKey:tableID];
//        [dict setObject:value forKey:fieldName];
//        [self showLoadingHUDWithTitle:saveTips SubTitle:nil];
//        
//        HHttpRequest *manager = [[HHttpRequest new]init];
//        [manager httpPostRequestWithActionName:actionName
//                                   andPramater:dict
//                          andDidDataErrorBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//                              [self.hudLoading hide:YES];
//                          } andDidRequestSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//                              [self.hudLoading hide:YES];
//                              [self.navigationController popViewControllerAnimated:YES];
//                              if (self.saveBtnCilck) {
//                                  _saveBtnCilck(value);
//                              }
//                          } andDidRequestFailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                              [self.hudLoading hide:YES];
//                          }];
    }
}


/**
 *  按键盘的完成键保存数据
 *
 *  @param textField
 *
 *  @return YES
 */
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [txtFieldName resignFirstResponder];
    [self btnSave];
    return YES;
}

#pragma mark UITextView 代理方法
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        lblTip.text = placeholder;
    }else{
        lblTip.text = @"";
    }
}

@end

