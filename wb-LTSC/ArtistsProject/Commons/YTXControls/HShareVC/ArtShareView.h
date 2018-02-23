//
//  HShareVC
//
//  Created by HeLiulin on 15/10/29.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPopVC.h"
#import "OpenShareHeader.h"
#import "CangyouQuanDetailModel.h"

@interface ArtShareView : UIView

- (void)showShareView; //显示shareView
- (void)dismissSemiModalView; //隐藏shareView

@property(nonatomic,assign) BOOL deleteEdit;

@property(nonatomic,copy) NSString *topictype;
@property(nonatomic,readwrite) int numberOfColumns;
@property(nonatomic,strong)CangyouQuanDetailModel *topicModel;
@property (nonatomic, copy) void(^selectShoucangCilck)();
@property (nonatomic, copy) void(^selectJubaoCilck)();
@property (nonatomic, copy) void(^selectShanchuCilck)();
@property (nonatomic, copy) void(^selectEditClick)();
@property (nonatomic, copy) void(^selectDingzhiCilck)();//顶置
//专家预约和鉴定会没有收藏功能
@property(nonatomic,strong)NSString *state;
@property (nonatomic,strong)UIImage  *shareimage;
@property (nonatomic,strong)NSString *shareurl;//分享url
@property (nonatomic,strong)NSString *sharetitle;
@property (nonatomic,strong)NSString *sharedes;//描述内容
@end
