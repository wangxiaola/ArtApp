//
//  AdUrlTool.m
//  meishubao
//
//  Created by 胡亚刚 on 2017/7/4.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "AdUrlTool.h"
#import "GeneralConfigure.h"

@implementation AdUrlTool

+ (AdOpenTypeModel *)typeWithAdUrl:(NSString *)adUrl {

    if (!adUrl || adUrl.length == 0) {
        return nil;
    }

    AdOpenTypeModel * typeModel = [AdOpenTypeModel new];

    NSString *urlEncode = [adUrl stringByRemovingPercentEncoding];
    NDLog(@"url === %@---%@", adUrl,urlEncode);
    NSRange range = [urlEncode rangeOfString:@"bb:open_native"];
    if (range.location != NSNotFound) {
        NSString *propertys = [urlEncode substringFromIndex:(NSInteger)(range.location)];
//http://dev.benbun.com/web/proj/meishubao/Home/Index/detail/relaId/14130&bb:open_native=article%2Fdetail&bb:applink_data=%7B%22post_id%22%3A14130%7D
        NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        //NSLog(@"数组：%@",subArray);
        for (int j = 0 ; j < subArray.count; j++){
            //在通过=拆分键和值
            NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
            //给字典加入元素
            [tempDic setObject:dicArray[1] forKey:dicArray[0]];
        }
        NDLog(@"打印参数列表生成的字典：%@", tempDic);

        if ([[tempDic valueForKey:@"bb:open_native"] isEqualToString:@"artist/profile"]) {

            NSString *jsonStr = [tempDic valueForKey:@"bb:applink_data"];

            NSDictionary *param = [NSString dictionaryWithJsonString:jsonStr];

            typeModel.openType = AdOpenTypeArtist;
            typeModel.contentId = [param[@"artist_id"] stringValue];
        }

        if ([[tempDic valueForKey:@"bb:open_native"] isEqualToString:@"article/detail"]) {

            NSString *jsonStr = [tempDic valueForKey:@"bb:applink_data"];

            NSDictionary *param = [NSString dictionaryWithJsonString:jsonStr];

            typeModel.openType = AdOpenTypeArticle;
            typeModel.contentId = [param[@"post_id"] stringValue];
        }
    }else if ([urlEncode containsString:@"video_id="]) {

        NSString * videoId = [urlEncode componentsSeparatedByString:@"video_id="].lastObject;
        if ([NSString notNilString:videoId].length > 0) {
            typeModel.openType = AdOpenTypeVideo;
            typeModel.contentId = [NSString notNilString:videoId];
        }
    }else {

        typeModel.openType = AdOpenTypeDefault;
    }
    return typeModel;
}

@end

@implementation AdOpenTypeModel

@end
