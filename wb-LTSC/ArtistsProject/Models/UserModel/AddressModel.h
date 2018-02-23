//
//  AddressModel.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject<YYModel,NSCoding>
@property (nonatomic, copy) NSString * aid;
@property (nonatomic, copy) NSString * defaultStr;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * address;
@end
