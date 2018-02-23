//
//  MSBCommentView.h
//  meishubao
//
//  Created by T on 16/11/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SuccessBlock)(NSString *commentText);

@protocol MSBCommentViewDelegate <NSObject>
@optional
- (void)commentDidFinished:(NSString *)commentText;
@end

@interface MSBCommentView : UIView
+ (void)commentshowInView:(UIView *)view success:(SuccessBlock)success;
+ (void)commentshowInView:(UIView *)view delegate:(id <MSBCommentViewDelegate>)delegate;
+ (void)commentshowSuccess:(SuccessBlock)success;
+ (void)commentshowDelegate:(id <MSBCommentViewDelegate>)delegate;
@end
