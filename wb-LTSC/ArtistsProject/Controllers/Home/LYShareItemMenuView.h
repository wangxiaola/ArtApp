//
//  HomeController.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#define kShareItemWidth  60
#define kShareItemHeight  90
#import <UIKit/UIKit.h>
#import "LYShareMenuItem.h"
@interface LYShareMenuItemView : UIView

@property (nonatomic, strong) UIButton *shareItemButton;
@property (nonatomic, strong) UILabel  *shareItemDesLabel;/**< 描述 */

- (void)configureWithShareItem:(LYShareMenuItem *)shareMenuItem;
- (void)itemViewAnimation;

@end
