//
//  ItemHeaderView.m
//  meishubao
//
//  Created by LWR on 2017/4/24.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "ItemHeaderView.h"
#import "GeneralConfigure.h"

@implementation ItemHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setup {

    _sectionTitle           = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
    _sectionTitle.font      = [UIFont systemFontOfSize:12];
    _sectionTitle.dk_textColorPicker =  DKColorSwiftWithRGB(0x000000, 0x989898);
    [self addSubview:_sectionTitle];
}

@end
