//
//  YTXAddressTableViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXAddressTableViewCell.h"
#import "YTXAddAddressViewController.h"

NSString * kYTXAddressTableViewCell = @"YTXAddressTableViewCell";
@interface YTXAddressTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameAndPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation YTXAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editBtnAction:(id)sender {
    if (_editBtnAcionBlock) {
        _editBtnAcionBlock();
    }
}

- (void)setModel:(YTXAddressViewModel *)model {
    _model = model.modelCopy;
    if (_model.isDefault) {
        _imageWidth.constant = 40;
        _nameAndPhoneLabel.textColor = kRedColor;
    } else {
        _imageWidth.constant = 0;
        _nameAndPhoneLabel.textColor = [UIColor blackColor];
    }
    
    _nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@ %@",[NSString stripNullWithString:_model.name],[NSString stripNullWithString:_model.phone]];
    _addressLabel.text = _model.address;
}

+ (CGFloat)heightForViewModel:(YTXAddressViewModel *)model {
    CGFloat height = 42;
    CGFloat width = 0;
    if (model.isDefault) {
        width = kScreenW - 46;
    } else {
        width = kScreenW - 46 - 40;
    }
    CGSize size = [model.address sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(width, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    height += size.height;
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
