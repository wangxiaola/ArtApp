//
//  MSBShareCommentView.h
//  meishubao
//
//  Created by T on 16/12/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^replyCommentBlock) (NSString *);
typedef void (^reportCommentBlock) (NSString *);
static const CGFloat kMSBShareCommentViewH = 162.f;
typedef NS_ENUM(NSUInteger, MSBShareCommentType) {
    MSBShareCommentTypeAnswer = 1,
    MSBShareCommentTypeZhuanfa,
    MSBShareCommentTypeCopy,
    MSBShareCommentTypeStore,
    MSBShareCommentTypeSystem,
    MSBShareCommentTypeMsg,
    MSBShareCommentTypeMail,
    MSBShareCommentTypeJubao
};

@interface MSBShareCommentView : UIView
+ (instancetype)shareInstance;
@property (nonatomic, weak) BaseViewController  *articleDetialVC;
@property (nonatomic, copy) NSString *msb_copyContent;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) replyCommentBlock replyBlock;
@property (nonatomic, copy) reportCommentBlock reportBlock;
-(void)replyComment: (replyCommentBlock)block;
-(void)reportComment: (reportCommentBlock)block;
- (void)show;
- (void)dismiss;
@end
