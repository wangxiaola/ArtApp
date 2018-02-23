//
//  BBCommentView.h
//  adquan
//
//  Created by Benbun on 15/8/5.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBCommentView;

@protocol BBCommentViewDelegate <NSObject>
@optional
- (void)commentViewDidClickCommentBtn:(BBCommentView *)commentView textView:(UITextView *)textView;
@end


typedef void(^BBCommentBlock)(NSString *);

@interface BBCommentView : UIView
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) id<BBCommentViewDelegate> delegate;
@property (nonatomic, assign) BOOL firstRespond;
@property(nonatomic,strong) NSNumber *commentId;
@property (nonatomic, copy) BBCommentBlock commentBlock;

@end
