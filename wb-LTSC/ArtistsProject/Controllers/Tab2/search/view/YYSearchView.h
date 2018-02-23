//
//  YYSearchView.h
//  YYSearchView
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Jack YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYSearchView : UIView

@property (strong,nonatomic)void (^YYGetTitle)(NSString * Title);
@property (strong,nonatomic)void (^YYGetCancel)(NSString * Title);
@property (weak, nonatomic) IBOutlet UIView *YYBgView;
@property (weak, nonatomic) IBOutlet UITextField *YYSearch;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

/**
 *  创建视图
 *
 *  @return <#return value description#>
 */
+(instancetype)creatView;

@end
