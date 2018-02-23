//
//  CorrelationVideoModel.h
//  meishubao
//
//  Created by 胡亚刚 on 2017/7/11.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "BaseModel.h"

@interface CorrelationVideoModel : BaseModel

@property (nonatomic,copy) NSString * video_id;
@property (nonatomic,copy) NSString * video_title;
@property (nonatomic,copy) NSString * video;
@property (nonatomic,copy) NSString * video_image;
@property (nonatomic,copy) NSString * video_url;

@end
