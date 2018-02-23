//
//  IntroVc.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ScrollViewController.h"

@interface IntroVc : ScrollViewController
@property (nonatomic, copy) void(^scrollCilck)(CGFloat);
@end
