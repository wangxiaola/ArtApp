//
//  ArticleImageModel.m
//  meishubao
//
//  Created by benbun－mac on 17/1/19.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "ArticleImageModel.h"
#import "MJExtension.h"
#import "NSString+Extension.h"
#import "GeneralConfigure.h"

@implementation ArticleImageModel

MJCodingImplementation

- (instancetype)init {
    if (self = [super init]) {
        self.name = @"";
        self.desc = @"";
    }
    return self;
}

-(void)setUrl:(NSString *)url {

    _url = [NSString imageUrlString:url];
}

- (void)setHeight:(CGFloat)height {

    _height = height;
}

- (void)setWidth:(CGFloat)width {

    //比例换算
    _width = ((SCREEN_WIDTH * 180 / 375.0) * width) / (self.height);
}

@end
