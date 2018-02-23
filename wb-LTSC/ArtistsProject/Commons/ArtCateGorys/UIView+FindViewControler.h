//
//  UIView+FindViewControler.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/7.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FindViewControler)
- (UIViewController *)containingViewController;
- (id) traverseResponderChainForUIViewController;

@end
