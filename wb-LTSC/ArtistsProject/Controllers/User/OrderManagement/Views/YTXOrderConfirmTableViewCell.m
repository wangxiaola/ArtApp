//
//  YTXOrderConfirmTableViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderConfirmTableViewCell.h"

NSString * const kYTXOrderConfirmTableViewCell = @"YTXOrderConfirmTableViewCell";

@interface YTXOrderConfirmTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *InfoBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *MinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *corfirmBtn;


@end

@implementation YTXOrderConfirmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer * tapG =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddressAction)];
    _InfoBackgroundView.userInteractionEnabled = YES;
    [_InfoBackgroundView addGestureRecognizer:tapG];
    _MinusBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _MinusBtn.layer.borderWidth = 0.5f;
    _plusBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _plusBtn.layer.borderWidth = 0.5f;
    _numberText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _numberText.layer.borderWidth = 0.5f;
    _corfirmBtn.layer.cornerRadius = 5;
    // Initialization code
}

- (void)setModel:(YTXOrderConfirmViewModel *)model {
    _model = model.modelCopy;
    _nameLabel.text = _model.name;
    _phoneLabel.text = _model.phone;
    _addressLabel.text = _model.address;
    [_goodsImageView setImageWithURL:_model.imageURL placeholder:nil];
    _numberText.text = _model.buyCount;
    _priceLabel.text = [NSString stringWithFormat:@"单价：%.2f元",_model.price.floatValue/100];
    _freightLabel.text = _model.freight;
    _totalPriceLabel.text = [NSString stringWithFormat:@"实付款：￥%.2f",(_model.price.floatValue + _model.freight.floatValue)/100];
    _goodsNameLabel.text = _model.goodsName;
}

//选择收货地址
- (void)selectAddressAction {
    if (_selectAddressActionBlock) {
        _selectAddressActionBlock();
    }
}

- (IBAction)minusBtnAction:(id)sender {
    NSInteger number = _numberText.text.integerValue;
    if (number <= 1) {
//        _MinusBtn.enabled = NO;
        return;
    }
    if (number > 1) {
        _plusBtn.enabled = YES;
        _numberText.text = [NSString stringWithFormat:@"%ld",(long)--number];
        _totalPriceLabel.text = [NSString stringWithFormat:@"实付款：%.2f",number * _model.price.floatValue + _model.freight.floatValue];
        if (_buyCountChangeAction) {
            _buyCountChangeAction(number);
        }
    }
}
- (IBAction)plusBtnAction:(id)sender {
    NSInteger number = _numberText.text.integerValue;
    if (number == 1) {
        _MinusBtn.enabled = YES;
    }
    if (number == _model.stock.integerValue) {
//        _plusBtn.enabled = NO;
        return;
    }
    _numberText.text = [NSString stringWithFormat:@"%ld",(long)++number];
    _totalPriceLabel.text = [NSString stringWithFormat:@"实付款：%.2f",number * _model.price.floatValue + _model.freight.floatValue];
    if (_buyCountChangeAction) {
        _buyCountChangeAction(number);
    }
}
- (IBAction)confirmBtnAction:(id)sender {
    if (_confirmOrderActionBlock) {
        _confirmOrderActionBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
