//
//  YTXOrderListTableViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderListTableViewCell.h"
#import "YTXOrderViewModel.h"

#define kLabelH   70
#define kSpacing  15
NSString * const kYTXOrderListTableViewCell = @"YTXOrderListTableViewCell";

@interface YTXOrderInfoView : UIView

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * stateLabel1;
@property (nonatomic, strong) UILabel * stateLabel2;
@property (nonatomic, strong) UILabel * stateLabel3;
@property (nonatomic, strong) UILabel * contentLabel1;
@property (nonatomic, strong) UILabel * contentLabel2;
@property (nonatomic, strong) UILabel * contentLabel3;
@property (nonatomic, strong) UIView  *botView;
@end

@implementation YTXOrderInfoView

- (instancetype)init {
    if (self = [super init]) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    self.backgroundColor = [UIColor clearColor];
    [self timeLabel];
    [self stateLabel1];
    [self stateLabel2];
    [self stateLabel3];
    [self contentLabel2];
    [self contentLabel1];
    [self contentLabel3];
    [self botView];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.numberOfLines = 0;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(kSpacing);
            make.right.lessThanOrEqualTo(self.stateLabel1.mas_left).offset(-10);
        }];
    }
    return _timeLabel;
}

- (UILabel *)stateLabel1 {
    if (!_stateLabel1) {
        _stateLabel1 = [[UILabel alloc]init];
        _stateLabel1.textAlignment = NSTextAlignmentLeft;
        _stateLabel1.numberOfLines = 0;
        _stateLabel1.font = [UIFont systemFontOfSize:13];
        [self addSubview:_stateLabel1];
        [_stateLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kSpacing);
            make.right.equalTo(self).offset(-kSpacing);
            make.width.mas_equalTo(kLabelH);
        }];
    }
    return _stateLabel1;
}

- (UILabel *)contentLabel1 {
    if (!_contentLabel1) {
        _contentLabel1 = [[UILabel alloc]init];
        _contentLabel1.textAlignment = NSTextAlignmentLeft;
        _contentLabel1.numberOfLines = 0;
        _contentLabel1.font = [UIFont systemFontOfSize:13];
        [self addSubview:_contentLabel1];
        [_contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
            make.left.equalTo(self).offset(kSpacing);
            make.right.lessThanOrEqualTo(self.stateLabel2.mas_left).offset(-10);
        }];
    }
    return _contentLabel1;
}

- (UILabel *)stateLabel2 {
    if (!_stateLabel2) {
        _stateLabel2 = [[UILabel alloc]init];
        _stateLabel2.textAlignment = NSTextAlignmentLeft;
        _stateLabel2.numberOfLines = 0;
        _stateLabel2.font = [UIFont systemFontOfSize:13];
        [self addSubview:_stateLabel2];
        [_stateLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel1.mas_top);
            make.right.equalTo(self).offset(-kSpacing);
            make.width.mas_equalTo(kLabelH);
        }];
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
        [_contentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel1.mas_bottom).offset(5);
            make.left.equalTo(self).offset(kSpacing);
            make.right.lessThanOrEqualTo(self.stateLabel3.mas_left).offset(-10);
        }];
    }
    return _contentLabel2;
}
- (UILabel *)stateLabel3 {
    if (!_stateLabel3) {
        _stateLabel3 = [[UILabel alloc]init];
        _stateLabel3.textAlignment = NSTextAlignmentLeft;
        _stateLabel3.numberOfLines = 0;
        _stateLabel3.font = [UIFont systemFontOfSize:13];
        [self addSubview:_stateLabel3];
        [_stateLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel2.mas_top);
            make.right.equalTo(self).offset(-kSpacing);
            make.width.mas_equalTo(kLabelH);
        }];
    }
    return _stateLabel3;
}
- (UILabel *)contentLabel3 {
    if (!_contentLabel3) {
        _contentLabel3 = [[UILabel alloc]init];
        _contentLabel3.textAlignment = NSTextAlignmentLeft;
//        _contentLabel3.numberOfLines = 0;
        _contentLabel3.font = [UIFont systemFontOfSize:13];
        [self addSubview:_contentLabel3];
        [_contentLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel2.mas_bottom).offset(5);
            make.left.equalTo(self).offset(kSpacing);
            make.right.equalTo(self).offset(-kSpacing);
        }];
    }
    return _contentLabel3;
}


- (UIView*)botView {
    if (!_botView) {
        _botView = [[UIView alloc]init];
//        _botView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_botView];
        [_botView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-0.5);
            make.left.equalTo(self).offset(kSpacing);
            make.right.equalTo(self).offset(-kSpacing);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _botView;
}

@end

@interface YTXOrderListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) YTXOrderInfoView * userInfoView;// 信息
@property (nonatomic, strong) YTXOrderInfoView * userCancelView;// 取消
@property (nonatomic, strong) YTXOrderInfoView * userPaymentInfoView;//支付
@property (nonatomic, strong) YTXOrderInfoView * userSendInfoView;// 发货
@property (nonatomic, strong) YTXOrderInfoView * userRecInfoView;// 收货
@property (nonatomic, strong) YTXOrderInfoView * commentInfoView;// 回评
@property (nonatomic, strong) YTXOrderInfoView * commentBackView;// 追评

// 评论
@property (nonatomic, assign) CGFloat pinglunH;
@property (nonatomic, assign) CGFloat huipingH;
@property (nonatomic, assign) CGFloat zhuipingH;
@end

@implementation YTXOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _firstBtn.layer.cornerRadius = 4;
    _secondBtn.layer.cornerRadius = 4;
    // Initialization code
}

- (void)setModel:(YTXOrderViewModel *)model {
//    model.pinglun = @"买家评论:很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。";
//    model.huiping = @"卖家评论: 很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。卖家评论: 很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。";
//    model.zhuiping = @"卖家评论: 很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。很好的购物体验，卖家很专业很用心，物超所值价美物廉，非常喜欢这次购物，很不错的哦。";
    _model = model.modelCopy;
    _timeLabel.text = [NSString stringWithFormat:@"创建时间：%@",_model.createTime];
    _orderIDLabel.text = [NSString stringWithFormat:@"订单号：%@",_model.orderID];
    if (_model.imageURL) {
        [self.goodsImageVIew setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!120a", _model.imageURL]] placeholder:[UIImage imageNamed:@"icon_Default_Product"]];
    }else{
        [self.goodsImageVIew setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!120a", [_model.photo componentsSeparatedByString:@","].firstObject]] placeholder:[UIImage imageNamed:@"icon_Default_Product"]];
    }
    _goodsNameLabel.text = _model.goodsName;
    _shopNameLabel.text = _model.shopName;
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",(_model.price.floatValue + _model.yunfei.floatValue)/100];
    if (_model.firstBtnName.length > 0) {
        [_firstBtn setTitle:_model.firstBtnName forState:UIControlStateNormal];
        if (_model.firBtnColor) {
            [_firstBtn setBackgroundColor:_model.firBtnColor];
        }
        _firstBtn.hidden = NO;
    } else {
        _firstBtn.hidden = YES;
    }
    if (_model.SecondBtnName.length > 0) {
        [_secondBtn setTitle:_model.SecondBtnName forState:UIControlStateNormal];
        _secondBtn.hidden = NO;
        if (_model.secondBtnColor) {
            [_secondBtn setBackgroundColor:_model.secondBtnColor];
        }
    }else{
        _secondBtn.hidden = YES;
    }
    [self userInfoView];
    [self userCancelView];
    [self userPaymentInfoView];// 支付
    [self userSendInfoView];// 发货
    [self userRecInfoView];// 收货
    [self commentInfoView];// 卖家回评
    [self commentBackView];// 买家追评
    // 收货信息
    if (_model.shopName.length > 0) {
        self.userInfoView.timeLabel.text = [NSString stringWithFormat:@"下单时间:%@",_model.createTime];
        self.userInfoView.contentLabel1.text = _model.shopName;// 姓名
        self.userInfoView.contentLabel2.text = [NSString stringWithFormat:@"%@",_model.phone];
        self.userInfoView.contentLabel3.text = [NSString stringWithFormat:@"%@",_model.address];
        self.userInfoView.botView.backgroundColor = [UIColor lightGrayColor];
    }
    // 取消订单
    if (_model.reason.length > 0) {
        self.userCancelView.timeLabel.text = [NSString stringWithFormat:@"取消时间:%@",_model.createTime];
        self.userCancelView.contentLabel1.text = _model.reason;// 原因
        self.userCancelView.contentLabel2.text = [NSString stringWithFormat:@"%@",_model.phone];
        self.userCancelView.contentLabel3.text = [NSString stringWithFormat:@"%@",_model.address];
        self.userCancelView.botView.backgroundColor = [UIColor lightGrayColor];
    }
    // 支付
    if (_model.payTime.doubleValue > 0) {//已支付
        self.userPaymentInfoView.timeLabel.text = [NSString stringWithFormat:@"支付时间:%@",[_model.payTime stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
        self.userPaymentInfoView.stateLabel1.text = @"已成功付款";
        self.userPaymentInfoView.contentLabel1.text = [NSString stringWithFormat:@"支付金额:%.2f 元",[_model.price floatValue]/100];
        self.userPaymentInfoView.botView.backgroundColor = [UIColor lightGrayColor];
    }
    // 发货
    if (_model.sendtime.doubleValue > 0) {//已发货
        self.userSendInfoView.timeLabel.text = [NSString stringWithFormat:@"发货时间:%@",[_model.sendtime stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
        self.userSendInfoView.stateLabel1.text = @"卖家已发货";
        self.userSendInfoView.contentLabel1.text = [NSString stringWithFormat:@"快递公司:%@",_model.expname];
        self.userSendInfoView.contentLabel2.text = [NSString stringWithFormat:@"快递单号:%@",_model.expnum];
        self.userSendInfoView.botView.backgroundColor = [UIColor lightGrayColor];
    }
    // 收货
    if (_model.rectime.doubleValue > 0) {//已确认收货
        self.userRecInfoView.timeLabel.text = [NSString stringWithFormat:@"收货时间:%@",[_model.rectime stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
        self.userRecInfoView.stateLabel1.text = @"已确认收货";
        self.userRecInfoView.contentLabel1.text = [NSString stringWithFormat:@"买家评分: %@分",_model.score];
        self.userRecInfoView.contentLabel2.text = [NSString stringWithFormat:@"%@",model.pinglun];
        CGFloat height = [self getCellHeightWithText:model.pinglun];
        [self.userRecInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        _pinglunH = height+50;
        self.userRecInfoView.botView.backgroundColor = [UIColor lightGrayColor];
        
    }
    // 回评
    if (_model.huiping.length > 0) {
        self.commentInfoView.timeLabel.text = [NSString stringWithFormat:@"回评时间:%@",[_model.rectime stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
        self.commentInfoView.stateLabel1.text = @"卖家回评";
        self.commentInfoView.contentLabel1.text = [NSString stringWithFormat:@"%@",model.huiping];
        self.commentInfoView.botView.backgroundColor = [UIColor lightGrayColor];
        CGFloat height = [self getCellHeightWithText:model.huiping];
        _huipingH = height;
        [self.commentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height-21);
        }];
    }
    // 追评
    if (_model.zhuiping.length > 0) {
        self.commentBackView.timeLabel.text = [NSString stringWithFormat:@"追评时间:%@",[_model.rectime stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
        self.commentBackView.stateLabel1.text = @"买家追评";
        self.commentBackView.contentLabel1.text = _model.zhuiping;
        self.commentBackView.botView.backgroundColor = [UIColor lightGrayColor];
        
        CGFloat height = [self getCellHeightWithText:_model.zhuiping];
        _zhuipingH = height;
        [self.commentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height-21);
        }];
    }
}

- (CGFloat)getCellHeightWithText:(NSString *)text
{
    // 通过文字获得文字的长宽
    //第一个参数: 动态rect的size基准(CGFLOAT_MAX 浮点型最大值)
    CGSize baseSize = CGSizeMake(kScreenWidth - 110, CGFLOAT_MAX);
    //第二个参数: 给API规定的枚举值
    // NSStringDrawingUsesLineFragmentOrigin
    // 第三个参数: 影响动态高度的文字相关属性(字体17是文字当前字体大小,没有规定字体大小默认17号)
    NSDictionary *attrDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rectToFit = [text boundingRectWithSize:baseSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attrDic context:nil];
    return  rectToFit.size.height+72;
}

// 用户信息
- (YTXOrderInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[YTXOrderInfoView alloc]init];
        [_bottomView addSubview:_userInfoView];
        [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_bottomView);
            make.height.mas_equalTo(110);
        }];
    }
    return _userInfoView;
}
// 取消订单
- (YTXOrderInfoView *)userCancelView {
    if (!_userCancelView) {
        _userCancelView = [[YTXOrderInfoView alloc]init];
        [_bottomView addSubview:_userCancelView];
        [_userCancelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_bottomView);
            make.top.equalTo(self.userInfoView.mas_bottom).offset(0);
            make.height.mas_equalTo(70);
        }];
    }
    return _userCancelView;
}

//用户支付
- (YTXOrderInfoView *)userPaymentInfoView {
    if (!_userPaymentInfoView) {
        _userPaymentInfoView = [[YTXOrderInfoView alloc]init];
        [_bottomView addSubview:_userPaymentInfoView];
        [_userPaymentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_bottomView);
            make.top.equalTo(self.userInfoView.mas_bottom).offset(0);
            make.height.mas_equalTo(75-8);
        }];
    }
    return _userPaymentInfoView;
}
// 卖家发货
- (YTXOrderInfoView *)userSendInfoView {
    if (!_userSendInfoView) {
        _userSendInfoView = [[YTXOrderInfoView alloc]init];
        [_bottomView addSubview:_userSendInfoView];
        [_userSendInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_bottomView);
            make.top.equalTo(self.userPaymentInfoView.mas_bottom).offset(0);
            make.height.mas_equalTo(88);
        }];
    }
    return _userSendInfoView;
}
// 买家收货
- (YTXOrderInfoView *)userRecInfoView {
    if (!_userRecInfoView) {
        _userRecInfoView = [[YTXOrderInfoView alloc]init];
        [_bottomView addSubview:_userRecInfoView];
        [_userRecInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_bottomView);
            make.top.equalTo(self.userSendInfoView.mas_bottom).offset(0);
//            make.height.mas_equalTo(80);
        }];
    }
    return _userRecInfoView;
}
// 卖家回评
- (YTXOrderInfoView *)commentInfoView {
    if (!_commentInfoView) {
        _commentInfoView = [[YTXOrderInfoView alloc]init];
        [_bottomView addSubview:_commentInfoView];
        [_commentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_bottomView);
            make.top.equalTo(self.userRecInfoView.mas_bottom).offset(0);
//            make.height.mas_equalTo(50);
        }];
    }
    return _commentInfoView;
}
// 买家追评
- (YTXOrderInfoView *)commentBackView {
    if (!_commentBackView) {
        _commentBackView = [[YTXOrderInfoView alloc]init];
        [_bottomView addSubview:_commentBackView];
        if (_model.huiping.length > 0) {
        [_commentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_bottomView);
            make.top.equalTo(self.commentInfoView.mas_bottom).offset(0);
//            make.height.mas_equalTo(50);
        }];
        }else{
            [_commentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_bottomView);
                make.top.equalTo(self.userRecInfoView.mas_bottom).offset(5);
//                make.height.mas_equalTo(50);
            }];
        }
    }
    return _commentBackView;
}

- (IBAction)btnAction:(UIButton *)sender {
    if (_btnActionBlock) {
        _btnActionBlock(sender.titleLabel.text);
    }
}

+ (CGFloat)getCellHeightWithModel:(YTXOrderViewModel *)model
{
    // 通过文字获得文字的长宽
    //第一个参数: 动态rect的size基准(CGFLOAT_MAX 浮点型最大值)
    CGSize baseSize = CGSizeMake(kScreenWidth - 110, CGFLOAT_MAX);
    //第二个参数: 给API规定的枚举值
    // NSStringDrawingUsesLineFragmentOrigin
    // 第三个参数: 影响动态高度的文字相关属性(字体17是文字当前字体大小,没有规定字体大小默认17号)
    NSDictionary *attrDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect pinglun = [model.pinglun boundingRectWithSize:baseSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attrDic context:nil];
    CGRect huiping = [model.huiping boundingRectWithSize:baseSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attrDic context:nil];
    CGRect zhuiping = [model.zhuiping boundingRectWithSize:baseSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attrDic context:nil];
    if (IS_IPHONE_5) {
        if (model.zhuiping.length > 0) {
            return kScreenH+pinglun.size.height+huiping.size.height+zhuiping.size.height+30;
            ;
        }else if (model.huiping.length > 0) {
            return kScreenH+huiping.size.height+pinglun.size.height+30;
            ;
        }else if (model.pinglun.length > 0) {
            return kScreenH+pinglun.size.height+30;
            ;
        }else{
            return kScreenH-64;
        }
    }else{
       if (model.zhuiping.length > 0) {
           return 568+pinglun.size.height+huiping.size.height + zhuiping.size.height+30;
       }else if (model.huiping.length > 0) {
           return 568+huiping.size.height+pinglun.size.height+30;
       }else if (model.pinglun.length > 0) {
           return kScreenH+pinglun.size.height+568+30;
       }else{
           return kScreenH-64;
       }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
