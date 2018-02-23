//
//  AnyWorkListCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/7.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCheckBox.h"
#import "sendBtn.h"

@class CangyouQuanDetailModel;
@interface AnyWorkListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImg;
@property(nonatomic,strong)sendBtn* chkDefault;
@property(nonatomic,strong)CangyouQuanDetailModel* model;
-(void)setAnyWorkListDic:(NSDictionary*)dic;
@property(nonatomic, copy)void(^detailBtnCilck)(NSDictionary*);
@end
