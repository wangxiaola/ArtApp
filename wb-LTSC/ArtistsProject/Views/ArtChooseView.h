//
//  ArtChooseView.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtBaseView.h"

@interface ArtChooseView : ArtBaseView
@property(strong,nonatomic)NSArray *arrayTitle;
@property(strong,nonatomic)NSArray *subTitleArr;
@property(copy,nonatomic)NSString *introBtnTitle;
@property (nonatomic,readwrite)int selectedPageIndex;
@property (nonatomic, copy)void(^selectBtnCilck)(NSInteger);
@end
