//
//  Ann30ImageModel.h
//  meishubao
//
//  Created by benbun－mac on 17/2/28.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ann30ImageModel : NSObject
@property (nonatomic,copy) NSString * post_id;
@property (nonatomic,copy) NSString * comment_num;
@property (nonatomic,assign) BOOL is_collect;
@property (nonatomic,copy) NSArray * smeta;
@end
