//
//  MSBCommentBottom.h
//  meishubao
//
//  Created by T on 16/12/14.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^commentClickBlock)();

@interface MSBCommentBottom : UIView
@property (nonatomic, copy) commentClickBlock commentBlock;
@end
