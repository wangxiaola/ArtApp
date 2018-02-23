//
//  MenuChooseView.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/14.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuChooseView : UIScrollView
@property(strong,nonatomic)NSArray *arrayTitle;
@property(strong,nonatomic)NSArray *subTitleArr;
@property(copy,nonatomic)NSString *introBtnTitle;
@property (nonatomic,readwrite)int selectedPageIndex;
@property (nonatomic, copy)void(^selectBtnCilck)(NSInteger);
-(void)addBtnAndTitLabel;
@end
