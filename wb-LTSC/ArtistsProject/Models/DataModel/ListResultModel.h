//
//ListResultModel
//Create by Hell on 2015/09/09
//Copyright(c) 2015年 上海翔汇网络科技有限公司.All rights reserved.

#import <Foundation/Foundation.h>

@interface ListResultDataModel:NSObject

@property(nonatomic,strong) NSMutableArray *datalist;
@property(nonatomic,copy) NSString *pageTotal;
@property(nonatomic,copy) NSString *recordTotal;

@end

@interface ListResultModel:NSObject

//服务器响应时间戳
@property(nonatomic,copy) NSString *timestamp;
//平台签名，请配合token验证签名
@property(nonatomic,copy) NSString *signature;
//错误码
@property(nonatomic,copy) NSString *errCode;
//错误信息
@property(nonatomic,copy) NSString *errMsg;
@property(nonatomic,strong) ListResultDataModel *data;
@end