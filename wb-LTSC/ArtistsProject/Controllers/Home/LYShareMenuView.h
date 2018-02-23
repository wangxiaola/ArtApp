//
//  HomeController.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYShareItemMenuView.h"
@class LYShareMenuView;
@protocol LYShareMenuViewDelegate <NSObject>

@optional

- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index;

@end

@interface LYShareMenuView : UIView

@property (nonatomic, weak) id <LYShareMenuViewDelegate> delegate;
@property (nonatomic, strong) NSArray *shareMenuItems;

- (void)show;
@end


