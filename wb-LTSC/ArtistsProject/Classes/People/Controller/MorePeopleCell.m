//
//  MorePeopleCell.m
//  meishubao
//
//  Created by LWR on 2017/4/24.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MorePeopleCell.h"
#import "MorePeopleModel.h"
#import "GeneralConfigure.h"

@interface MorePeopleCell()

@property (nonatomic, strong) UIImageView *peoplePic;
@property (nonatomic, strong) UILabel     *peopleTitle;

@end

@implementation MorePeopleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x222222);
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    UIBezierPath *mask  = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 50, 50)];
    shape.path          = mask.CGPath;
    shape.strokeColor   = RGBCOLOR(162, 162, 162).CGColor;
    shape.fillColor     = [UIColor clearColor].CGColor;
    [self.contentView.layer addSublayer:shape];
    
    CGFloat marginLeft = 13.5;
    if (SCREEN_HEIGHT == 568) {
        
        marginLeft = 5.5;
    }
    
    shape.frame         = CGRectMake(marginLeft, 13, 50, 50);
    
    _peoplePic          = [[UIImageView alloc] initWithFrame:CGRectMake(marginLeft + 2.0, 15, 46, 46)];
    [self.contentView addSubview:_peoplePic];
    // 进行切割
    _peoplePic.layer.cornerRadius  = 23;
    _peoplePic.layer.masksToBounds = YES;
    _peoplePic.contentMode         = UIViewContentModeScaleAspectFill;
    
    CGFloat labX        = CGRectGetMaxX(_peoplePic.frame) + 4;
    _peopleTitle        = [[UILabel alloc] initWithFrame:CGRectMake(labX, 20, SCREEN_WIDTH - labX - 3, 36)];
    _peopleTitle.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898);
    _peopleTitle.font   = [UIFont boldSystemFontOfSize:14.0];
    _peopleTitle.numberOfLines = 0;
    [self.contentView addSubview:_peopleTitle];
}

- (void)setModel:(MorePeopleModel *)model {

    [_peoplePic sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"people_collection_cell"]];
    _peopleTitle.text = model.name;
}

@end


