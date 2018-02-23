//
//  YTXOrderOperateDetailCell.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "YTXOrderOperateDetailCell.h"

@implementation YTXOrderOperateDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self stateLabel1];
        [self stateLabel2];
        [self contentLabel2];
        [self contentLabel2];
    }
    return self;
}
- (UILabel *)stateLabel1 {
    if (!_stateLabel1) {
        _stateLabel1 = [[UILabel alloc]init];
        _stateLabel1.textAlignment = NSTextAlignmentLeft;
        _stateLabel1.numberOfLines = 0;
        _stateLabel1.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_stateLabel1];
        _stateLabel1.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .topSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentLabel1, 10)
        .heightIs(25);
    }
    return _stateLabel1;
}

- (UILabel *)contentLabel1 {
    if (!_contentLabel1) {
        _contentLabel1 = [[UILabel alloc]init];
        _contentLabel1.textAlignment = NSTextAlignmentLeft;
        _contentLabel1.numberOfLines = 0;
        _contentLabel1.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_contentLabel1];
        _contentLabel1.sd_layout
        .leftSpaceToView(self.contentLabel1, 10)
        .topSpaceToView(self.contentView, 10)
        .widthIs(100)
        .heightIs(25);
    }
    return _contentLabel1;
}

- (UILabel *)stateLabel2 {
    if (!_stateLabel2) {
        _stateLabel2 = [[UILabel alloc]init];
        _stateLabel2.textAlignment = NSTextAlignmentLeft;
        _stateLabel2.numberOfLines = 0;
        _stateLabel2.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_stateLabel2];
        _stateLabel2.sd_layout
        .leftEqualToView(self.stateLabel1)
        .topSpaceToView(self.stateLabel1, 10)
        .rightEqualToView(self.stateLabel1)
        .autoHeightRatio(0);
    }
    return _stateLabel2;
}

- (UILabel *)contentLabel2 {
    if (!_contentLabel2) {
        _contentLabel2 = [[UILabel alloc]init];
        _contentLabel2.textAlignment = NSTextAlignmentLeft;
        _contentLabel2.numberOfLines = 0;
        _contentLabel2.font = [UIFont systemFontOfSize:13];
        [self addSubview:_contentLabel2];
        _contentLabel2.sd_layout
        .leftEqualToView(self.contentLabel1)
        .topSpaceToView(self.contentLabel1, 10)
        .rightEqualToView(self.contentLabel1)
        .heightRatioToView(self.stateLabel2, 1);
    }
    return _contentLabel2;
}
- (UIView*)botView {
    if (!_botView) {
        _botView = [[UIView alloc]init];
        _botView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_botView];
        _botView.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .bottomSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 15)
        .heightIs(0.5);
    }
    return _botView;
}

+ (CGFloat)getCellHeightWithText:(NSString *)text
{
    // 通过文字获得文字的长宽
    //第一个参数: 动态rect的size基准(CGFLOAT_MAX 浮点型最大值)
    CGSize baseSize = CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX);
    //第二个参数: 给API规定的枚举值
    // NSStringDrawingUsesLineFragmentOrigin
    // 第三个参数: 影响动态高度的文字相关属性(字体17是文字当前字体大小,没有规定字体大小默认17号)
    NSDictionary *attrDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rectToFit = [text boundingRectWithSize:baseSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attrDic context:nil];
    return 60 + rectToFit.size.height;
}
+ (NSInteger)getCellNumberWithModel:(YTXOrderViewModel *)model
{
    if (model.zhuiping.length > 0) {
        return 5;
    }else if (model.huiping.length > 0){
        return 4;
    }else if (model.rectime.doubleValue > 0){
        return 3;
    }else if (model.sendtime.doubleValue > 0){
        return 2;
    }else if (model.payTime.length > 0){
        return 1;
    }else{
        return 1;
    }
}


@end
