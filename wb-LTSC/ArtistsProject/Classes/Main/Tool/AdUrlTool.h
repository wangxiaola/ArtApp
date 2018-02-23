//
//  AdUrlTool.h
//  meishubao
//
//  Created by 胡亚刚 on 2017/7/4.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
//广告、文章超链接等链接类型Model
typedef NS_ENUM(NSUInteger, AdOpenType) {
    AdOpenTypeDefault = 0,//默认普通链接
    AdOpenTypeArticle = 1,//H5文章
    AdOpenTypeArtist  = 2,//H5人物
    AdOpenTypeVideo  = 3  //视频
};

@interface AdOpenTypeModel : NSObject

@property (nonatomic,assign) AdOpenType openType;
@property (nonatomic,copy) NSString * contentId;//文章或者人物ID

@end

@interface AdUrlTool : NSObject
//通过url返回链接打开类型
+ (AdOpenTypeModel *)typeWithAdUrl:(NSString *)adUrl;

@end
