//
//  MSBAdSchedule.h
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSBAdModel;
@interface MSBAdSchedule : NSObject
/*! 请求日程 */
+ (void)requestSchedule;

/*! 当前播放内容二进制图片数据 */
+ (MSBAdModel *)currentAdSchedule;

@end
