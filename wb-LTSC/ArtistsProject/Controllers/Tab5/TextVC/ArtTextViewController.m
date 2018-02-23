//
//  ArtTextViewController.m
//  ShesheDa
//
//  Created by HELLO WORLD on 2017/3/23.
//  Copyright © 2017年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "ArtTextViewController.h"

@interface ArtTextViewController ()<UITextViewDelegate>{
    CGRect _Frmae;
}
@property(nonatomic,strong)UIScrollView* scroll;
@property(nonatomic,strong)UITextView* text;
@end

@implementation ArtTextViewController
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
    _Frmae = self.view.frame;
    self.navigationItem.title = @"简介";
    
    _text = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    _text.layer.borderWidth=1.0;
    _text.translatesAutoresizingMaskIntoConstraints = NO;
    _text.allowsEditingTextAttributes=YES;
    _text.layer.borderColor=kLineColor.CGColor;
    _text.editable = YES;
    _text.delegate=self;
    if (self.titleContent.length>0){
        _text.text = self.titleContent;
    }
    [self.view addSubview:_text];
    
    UIBarButtonItem * RightBarButton=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btnSave)];
    self.navigationItem.rightBarButtonItem=RightBarButton;
    
//    //设置导航栏返回按钮样式
//    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    customButton.frame = CGRectMake(0, 0, 14, 60);
//    [customButton addTarget:self action:@selector(leftBarItem_Click) forControlEvents:UIControlEventTouchUpInside];
//    [customButton setImage:[UIImage imageNamed:@"icon_navigationbar_back"] forState:UIControlStateNormal];
//    customButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    UIBarButtonItem* leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
- (void)UIKeyboardWillShowNotification:(NSNotification *) notification
{
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //将视图上移计算好的偏移
        [UIView animateWithDuration:duration animations:^{
           _text.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT-64-kbHeight);
     }];
}

- (void)keyboardWillHide:(NSNotification *) notification{
    // 键盘动画时间cgf
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _text.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT-64);
    }];
}

-(void)btnSave{
     [_text becomeFirstResponder];
    NSString *value = _text.text;//获取新值
    
       if ([value length]>100) {
        //@"长度不能超过%d字符"
        [self showErrorHUDWithTitle:[NSString stringWithFormat:@"长度不能超过100字符"] SubTitle:nil Complete:^{
            
                }];
        return;
        
    }
            if(_saveBtnCilck){
            _saveBtnCilck(value);
        }
    [self.navigationController popViewControllerAnimated:YES];
    }

-(void)leftBarItem_Click{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  保存事件
 */

@end
