//
//  AudioModel.h
//  ShesheDa
//
//  Created by chen on 16/8/10.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioModel : NSObject

@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *duration;

@end

@interface AudioArrayModel : NSObject

@property(nonatomic,copy) NSMutableArray *likeuser;

@end