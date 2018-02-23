//
//  AddressModel.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
   
    return   [self modelInitWithCoder:aDecoder];
//        _uid = [aDecoder decodeObjectForKey:@"uid"];
//        _phone = [aDecoder decodeObjectForKey:@"phone"];
}
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
   return @{
                        @"aid" : @"id",
                        @"defaultStr" : @"default"
                        };
}
@end
