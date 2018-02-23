//
//  sendBtn.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/7.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "sendBtn.h"

@implementation sendBtn
@synthesize imgFrame = _imgFrame;
@synthesize titleFrame = _titleFrame;

- (id)init{
    if (self= [super init]) {
    }
    return self;
}
-(void)setImgFrame:(CGRect)imgFrame{
    _imgFrame = imgFrame;
}
-(void)setTitleFrame:(CGRect)titleFrame{
    _titleFrame = titleFrame;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
        return _imgFrame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return _titleFrame;
}
@end
