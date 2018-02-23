//
//  LoginResultModel.m
//  ShesheDa
//
//  Created by XICHUNZHAO on 15/12/23.
//  Copyright © 2015年 上海翔汇网络有限公司. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoUserModel

@end

@implementation UserInfoDataModel


@end

@implementation UserInfoModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.headPortrait forKey:@"headPortrait"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.provinceID forKey:@"provinceID"];
    [aCoder encodeObject:self.cityID forKey:@"cityID"];
    [aCoder encodeObject:self.areaID forKey:@"areaID"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.inviteCode forKey:@"inviteCode"];
    [aCoder encodeObject:self.inviteFrom forKey:@"inviteFrom"];
    [aCoder encodeObject:self.addTime forKey:@"addTime"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:self.vflag forKey:@"vflag"];
    [aCoder encodeObject:self.level forKey:@"level"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.crowdfundingStr forKey:@"crowdfundingStr"];
    [aCoder encodeObject:self.friendsCount forKey:@"friendsCount"];
    [aCoder encodeObject:self.fansCount forKey:@"fansCount"];
    [aCoder encodeObject:self.follwCount forKey:@"follwCount"];
    [aCoder encodeObject:self.notesCount forKey:@"notesCount"];
    [aCoder encodeObject:self.couponCount forKey:@"couponCount"];
    [aCoder encodeObject:self.pointSum forKey:@"pointSum"];
    [aCoder encodeObject:self.unpaidOrderCount forKey:@"unpaidOrderCount"];
    [aCoder encodeObject:self.paidOrderCount forKey:@"paidOrderCount"];
    [aCoder encodeObject:self.receiveOrderCount forKey:@"receiveOrderCount"];
    [aCoder encodeObject:self.orderCount forKey:@"orderCount"];
    [aCoder encodeObject:self.crowdfundingOrderCount forKey:@"crowdfundingOrderCount"];
    [aCoder encodeObject:self.unreadCount forKey:@"unreadCount"];
    [aCoder encodeObject:self.productCollectionCount forKey:@"productCollectionCount"];
    [aCoder encodeObject:self.notesCollectionCount forKey:@"notesCollectionCount"];
    [aCoder encodeObject:self.msg_token forKey:@"msg_token"];
    [aCoder encodeObject:self.acceptCrowdfundingMsg forKey:@"acceptCrowdfundingMsg"];
    [aCoder encodeObject:self.loginID forKey:@"loginID"];
    [aCoder encodeObject:self.viewPhone forKey:@"viewPhone"];
    [aCoder encodeObject:self.viewEmail forKey:@"viewEmail"];
    //[aCoder encodeObject:self.user forKey:@"user"];
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"user" : [UserInfoUserModel class],
            };
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    if (self=[super init]) {
        _userID = [aDecoder decodeObjectForKey:@"userID"];
        _phone = [aDecoder decodeObjectForKey:@"phone"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _headPortrait = [aDecoder decodeObjectForKey:@"headPortrait"];
        _sex = [aDecoder decodeObjectForKey:@"sex"];
        _age = [aDecoder decodeObjectForKey:@"age"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _provinceID = [aDecoder decodeObjectForKey:@"provinceID"];
        _cityID = [aDecoder decodeObjectForKey:@"cityID"];
        _areaID = [aDecoder decodeObjectForKey:@"areaID"];
        _status = [aDecoder decodeObjectForKey:@"status"];
        _inviteCode = [aDecoder decodeObjectForKey:@"inviteCode"];
        _inviteFrom = [aDecoder decodeObjectForKey:@"inviteFrom"];
        _addTime = [aDecoder decodeObjectForKey:@"addTime"];
        _signature = [aDecoder decodeObjectForKey:@"signature"];
        _point = [aDecoder decodeObjectForKey:@"point"];
        _vflag = [aDecoder decodeObjectForKey:@"vflag"];
        _level = [aDecoder decodeObjectForKey:@"level"];
        _province = [aDecoder decodeObjectForKey:@"province"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _area = [aDecoder decodeObjectForKey:@"area"];
        _crowdfundingStr = [aDecoder decodeObjectForKey:@"crowdfundingStr"];
        _friendsCount = [aDecoder decodeObjectForKey:@"friendsCount"];
        _fansCount = [aDecoder decodeObjectForKey:@"fansCount"];
        _follwCount = [aDecoder decodeObjectForKey:@"follwCount"];
        _notesCount = [aDecoder decodeObjectForKey:@"notesCount"];
        _couponCount = [aDecoder decodeObjectForKey:@"couponCount"];
        _pointSum = [aDecoder decodeObjectForKey:@"pointSum"];
        _unpaidOrderCount = [aDecoder decodeObjectForKey:@"unpaidOrderCount"];
        _paidOrderCount = [aDecoder decodeObjectForKey:@"paidOrderCount"];
        _receiveOrderCount = [aDecoder decodeObjectForKey:@"receiveOrderCount"];
        _orderCount = [aDecoder decodeObjectForKey:@"orderCount"];
        _crowdfundingOrderCount = [aDecoder decodeObjectForKey:@"crowdfundingOrderCount"];
        _unreadCount = [aDecoder decodeObjectForKey:@"unreadCount"];
        _productCollectionCount = [aDecoder decodeObjectForKey:@"productCollectionCount"];
        _notesCollectionCount = [aDecoder decodeObjectForKey:@"notesCollectionCount"];
        _msg_token = [aDecoder decodeObjectForKey:@"msg_token"];
        _acceptCrowdfundingMsg = [aDecoder decodeObjectForKey:@"acceptCrowdfundingMsg"];
        _loginID = [aDecoder decodeObjectForKey:@"loginID"];
        _viewPhone = [aDecoder decodeObjectForKey:@"viewPhone"];
        _viewEmail = [aDecoder decodeObjectForKey:@"viewEmail"];
         //_user = [aDecoder decodeObjectForKey:@"user"];
    }
    return self;
}
@end
