//
//  ArticleImageModel.h
//  meishubao
//
//  Created by benbun－mac on 17/1/19.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ArticleImageModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *priority;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;

@end
