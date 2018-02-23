//
//  AuthenticationModel.h
//  ShesheDa
//
//  Created by chen on 16/7/8.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationModel : NSObject
//认证提交的银行名
@property(nonatomic,copy) NSString *bank;
//认证提交的银行卡号
@property(nonatomic,copy) NSString *card;
// 认证提交的附加信息
@property(nonatomic,copy) NSString *info;
//认证提交的银行名
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *photo;
@property(nonatomic,copy) NSString *photo1;

@property(nonatomic,copy) NSString *realname;
@property(nonatomic,copy) NSString *reason;
@property(nonatomic,copy) NSString *uid;
// 用户认证类型1-鉴定专家 2-艺术家 3-收藏家 4-古玩店铺 5-拍卖行 13-批评家 14-策展人
@property(nonatomic,copy) NSString *user_verified_category_id;
//用户认证鉴定类型1-陶瓷 2-玉器 3-铜器 4-书画 5-钱币 6-杂项
@property(nonatomic,copy) NSString *catatype;
@property(nonatomic,copy) NSString *type;

// 认证状态    0代表审核中，1代表通过，2代表未认证
@property(nonatomic,copy) NSString *verified;
//店铺名称
@property(nonatomic, copy)NSString *shopname;
// 省份
@property(nonatomic, copy)NSString *province;
// 城市
@property(nonatomic, copy)NSString *city;
// 区域
@property(nonatomic, copy)NSString *area;
// 详细地址
@property(nonatomic, copy)NSString *location;

@property(nonatomic, copy)NSString *artwork;
@property(nonatomic, copy)NSString *wxphoto;
@property(nonatomic, copy)NSString *intro;
@property(nonatomic, copy)NSString *ename;
@property(nonatomic, copy)NSString *byyx;
@property(nonatomic, copy)NSString *xl;
@property(nonatomic, copy)NSString *sex;
@property(nonatomic, copy)NSString *birth;

@end
