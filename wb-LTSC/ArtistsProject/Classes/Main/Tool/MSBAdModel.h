//
//  MSBAdModel.h
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BaseModel.h"

@interface MSBAdModel : BaseModel

@property (nonatomic, assign) NSInteger id;
/*! 广告编号 */
@property (strong, nonatomic) NSString *adNo;
/*! 广告图片地址 */
@property (strong, nonatomic) NSString *adSrc;
/*! 广告链接 */
@property (strong, nonatomic) NSString *adHref;
/*! 推送城市 */
@property (strong, nonatomic) NSString *city;
/*! 开始时间 */
@property (assign, nonatomic) long long startTime;
/*! 结束时间 */
@property (assign, nonatomic) long long endTime;
/*! 是否打开链接 */
@property (assign, nonatomic) BOOL openLink;
/*! 播放时间 */
@property (assign, nonatomic) NSInteger duration;
/*! 缓存图片 */
@property (strong, nonatomic) NSData *adBinaryData;
@end
