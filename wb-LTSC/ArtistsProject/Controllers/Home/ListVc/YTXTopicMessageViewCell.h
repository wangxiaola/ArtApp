//
//  YTXTopicMessageViewCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CangyouQuanDetailModel;
@interface YTXTopicMessageViewCell : UITableViewCell

@property (nonatomic, strong) CangyouQuanDetailModel *detailModel;

@property (nonatomic, assign) BOOL isResult;

- (CGFloat)getHeight;



@end
