//
//  UIViewController+NavigationBarBtn.m
//  YunLianMeiGou
//
//  Created by 牛中磊 on 2017/5/18.
//  Copyright © 2017年 namei. All rights reserved.
//

#import "UIViewController+NavigationBarBtn.h"
#import "NSString+Util.h"

@implementation UIViewController (NavigationBarBtn)

-(void)addRightBtn:(NSString *)string{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 60, 20)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:COLOR_FROM_RGB(@"#FF5578", 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}



-(void)addRightLoading{
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activity startAnimating];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

/**
 其他viewController要重写此方法
 */
-(void)rightBtnAction{
    
}



-(void)addRightBarItemBtn:(NSString *)string titleColor:(UIColor *)titleColor{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 100, 20)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}






/**
 退换货流程按钮
 */
-(void)addRightBarItemBtn:(NSString *)string {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 100, 20)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:COLOR_FROM_RGB(@"#3E3E3E", 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightQuitMoneyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
}
-(void)rightQuitMoneyBtnAction {
    
}

-(void)rightPointCountBtnAction{
    
}
-(void)addRightBtnByImageNamed:(NSString *)imageNamed{
    
    // 消息按钮
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = CGRectMake(0, 0, 30, 30);
    msgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -10);
    [msgBtn setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(rightBtnByImageNamedBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msgBtn];

}

-(void)rightBtnByImageNamedBtnAction{
    
}

-(UIBarButtonItem *)addLeftBtnByImageNamed:(NSString *)imageNamed{
    
    UIBarButtonItem *theLeftItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:imageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(leftBtnByImageNamedAction)];
    self.navigationItem.leftBarButtonItem=theLeftItem;
    return theLeftItem;

}


-(void)cityAction{
    
}


// 其他导航定位
-(UIView *)addLocationBtn:(NSString *)cityName{
    
    CGSize size = [cityName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];
        //pointLabel的宽
   CGFloat width = size.width;
    
    if (width>70) {
        width=70;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0, width+15, 40)];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
    [leftBtn setTitle:cityName forState:UIControlStateNormal];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [leftBtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:leftBtn];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(width-5, 13, 12, 7)];

    rightView.image = [UIImage imageNamed:@"切换县区"];
    rightView.centerY = leftBtn.centerY;
    
    [bgView addSubview:rightView];

    //---------
    // 消息按钮
//    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    NSAttributedString *attributeCityName = [self getCity:cityName];
//
//    CGSize size = [cityName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];
//    //pointLabel的宽
//    CGFloat width = size.width+10;
//
////    CGFloat width = [cityName widthWithFont:[UIFont systemFontOfSize:13] constrainedToHeight:15]+ 22;
//    if (width > 40) {
//        width = 40;
//    }
//    msgBtn.frame = CGRectMake(0, 0, width, 40);
//    [msgBtn setAttributedTitle:attributeCityName forState:UIControlStateNormal];
//    msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [msgBtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
//    return msgBtn;
    return bgView;
}

-(void)addIndexNaivgationLeftItem:(NSString *)cityName{
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self addLocationBtn:cityName]];
}


// 首页定位
-(void)addLocationNaivgationLeftItem:(NSString *)cityName{
   
    CGFloat width = [cityName widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:20];
    if (width > 80) {
        width = 80;
    }
    UIView *bg = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, width, 40)];
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame =  CGRectMake(0, 0, width, 40);
    [msgBtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *title = [[UILabel alloc ] initWithFrame:CGRectMake(0, 23, width, 12)];
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = cityName;
    [bg addSubview:title];
    
    
    UIImageView *img = [[UIImageView alloc ] initWithFrame:CGRectMake((width-15)*0.5,3, 15, 18)];
    img.image = [UIImage imageNamed:@"index_location"];
    [bg addSubview:img];
    
    
    [bg addSubview:msgBtn];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bg];
}

-(NSAttributedString *)getCity:(NSString *)cityName{

    NSString *addressString = cityName;
    // 1.创建一个富文本
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:addressString];
    
    NSMutableParagraphStyle *paragraph=[[NSMutableParagraphStyle alloc]init];
    paragraph.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    [attri setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSParagraphStyleAttributeName:paragraph,
                           NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, cityName.length)];
    
    
    // 2.添加表情图片
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"切换县区"];
    // 设置图片大小
    attch.bounds = CGRectMake(4, 1, 12, 7);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:addressString.length];// 插入某个位置
    return attri;
}

-(void)addLeftBtnByTitle:(NSString *)title
{
    UIBarButtonItem *theLeftItem = [[UIBarButtonItem alloc ] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnByImageNamedAction)];
    [theLeftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem= theLeftItem;
}

-(void)addLeftBtnByTitle:(NSString *)title color:(UIColor *)color{
 
    UIBarButtonItem *theLeftItem = [[UIBarButtonItem alloc ] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnByImageNamedAction)];
    [theLeftItem setTintColor:color];
    [theLeftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem= theLeftItem;
}

-(void)leftBtnByImageNamedAction{
    [self.navigationController  popViewControllerAnimated:YES];
}

@end
