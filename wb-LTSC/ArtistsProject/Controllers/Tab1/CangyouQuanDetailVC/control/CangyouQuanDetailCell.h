//
//  CangyouQuanDetailCell.h
//  ShesheDa
//
//  Created by MengTuoChina on 16/7/23.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CangyouQuanDetailModel.h"

@protocol zhiDingProtocol<NSObject>
-(void)zhidingBtnClick;
@end

@protocol deleteProtocol<NSObject>
-(void)deleteBtnClick;
@end


@interface CangyouQuanDetailCell : UITableViewCell
@property(nonatomic,weak)id<zhiDingProtocol>manager;
@property(nonatomic,weak)id<deleteProtocol>delate;
@property (nonatomic, copy) NSString *topictype;
@property(nonatomic,copy)NSString* typeStr;
@property(nonatomic,strong)CangyouQuanDetailModel *topicModel;
@property(strong,nonatomic)CangyouQuanDetailModel *model;
@property(nonatomic,copy)NSString* isYiSuJiaJinKuang;

- (CGFloat)getHeight;
@end
