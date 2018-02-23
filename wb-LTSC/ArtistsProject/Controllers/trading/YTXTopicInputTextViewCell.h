//
//  YTXTopicInputTextViewCell.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/2.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTXTopicInputTextViewCell : UITableViewCell

@property (nonatomic, strong) void(^sendActionBlock)(NSString *text, NSString *reply);

- (void)becomeWithUserName:(NSString *)username replyId:(NSString *)replyId;

- (void)clearText;

@end
