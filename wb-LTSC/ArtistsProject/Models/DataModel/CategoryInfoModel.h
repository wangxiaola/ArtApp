//CategoryInfoModel.h
//Created by Hell on 2015/08/10
//Copyright(c) 2015年 上海翔汇网络科技有限公司.All rights reserved.
#import <Foundation/Foundation.h>

@interface CategoryInfoModel : NSObject

//编号
@property(nonatomic,copy) NSString *id;
//父上级分类ID
@property(nonatomic,copy) NSString *parentID;
//分类名称
@property(nonatomic,copy) NSString *categoryName;
//详细内容
@property(nonatomic,copy) NSString *contents;
//图片链接
@property(nonatomic,copy) NSString *picUrl;
//链接
@property(nonatomic,copy) NSString *linkUrl;
//排序
@property(nonatomic,copy) NSString *sortID;
//状态
@property(nonatomic,copy) NSString *status;
//添加时间
@property(nonatomic,copy) NSString *addTime;
//外链接
@property(nonatomic,copy) NSString *OutsideLink;
//提示
@property(nonatomic,copy) NSString *tips;

@property(nonatomic,strong) NSMutableArray<CategoryInfoModel*> *subCategoryList;

@property(nonatomic,readwrite) BOOL selected;

//banner图专用字段
// 1为商品 2为活动
@property(nonatomic,copy) NSString *type;
//商品ID或活动ID
@property(nonatomic,copy) NSString *productID;
//活动封面图
@property(nonatomic,copy) NSString *activityPicurl;
@end