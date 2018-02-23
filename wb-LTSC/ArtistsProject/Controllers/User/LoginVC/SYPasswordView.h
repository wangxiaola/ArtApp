//
//  VerifyVc.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SYPasswordView : UIView<UITextFieldDelegate>
/**
 *  清除密码
 */
- (void)clearUpPassword;
@property (nonatomic, copy) void(^selectBtnCilck)(NSString*);
-(void)popupKeyboard;
@end
