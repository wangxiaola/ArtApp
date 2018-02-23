//
//  MJSelectView.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJSelectView : UIView
@property(nonatomic,copy)NSString* defaultTitle;
@property(nonatomic,copy)void(^selectBlock)(NSString*);
@end
