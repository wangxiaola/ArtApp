//
//  YTXTopicMessageViewCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//
#import "YTXTopicMessageViewCell.h"
#import "CangyouQuanDetailModel.h"
#import "ArtCopyLabel.h"

#define SPACE       8

@interface YTXTopicMessageViewCell ()<UIWebViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *formatterLabel;
@property (nonatomic, strong) UITextView *messageLabel;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *sourceLabel;
//@property (nonatomic, strong) UILabel *viewLabel;
@property (nonatomic, strong) UIImageView *flagImageView;

@end

@implementation YTXTopicMessageViewCell

- (CGFloat)getHeight
{
    return _sourceLabel.bottom + SPACE;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.hidden = YES;
    self.subtitleLabel.hidden = YES;
    self.priceLabel.hidden = YES;
    self.formatterLabel.hidden = YES;
    self.messageLabel.hidden = YES;
    self.webView.hidden = YES;
    self.sourceLabel.hidden = YES;
    //self.viewLabel.hidden = YES;
    self.flagImageView.hidden = YES;
    CGFloat contentWidth = self.contentView.frame.size.width - SPACE * 2;
    if (_detailModel.topictype.integerValue == 2 ||
        _detailModel.topictype.integerValue == 3 ||
        _detailModel.topictype.integerValue == 7 ||
        _detailModel.topictype.integerValue == 13) {
        _messageLabel.hidden = NO;
        _sourceLabel.hidden = NO;
//        _viewLabel.hidden = NO;
        
        _messageLabel.text = _detailModel.message;
        _sourceLabel.text = _detailModel.sourceText;
//        _viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(self.contentView.frame.size.width - SPACE * 2, FLT_MAX)];
        _messageLabel.frame = CGRectMake(SPACE, SPACE, messageSize.width, messageSize.height);
        
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        _sourceLabel.frame = CGRectMake(SPACE, _messageLabel.bottom + 0, sourceSize.width, 0);
        
//        CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//        _viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _messageLabel.bottom + SPACE, viewSize.width, viewSize.height);
    } else if (_detailModel.topictype.integerValue == 1) {
        _formatterLabel.hidden = NO;
        _messageLabel.hidden = NO;
        _sourceLabel.hidden = NO;
        //_viewLabel.hidden = NO;
        if (_isResult)
        {
            self.flagImageView.hidden = NO;
            
            NSMutableString *string = [NSMutableString string];
            if (_detailModel.catetypeName.length > 0) {
                [string appendString:_detailModel.statusName];
                [string appendString:@" | "];
            }
            if (_detailModel.ageText.length > 0) {
                [string appendString:_detailModel.ageText];
                [string appendString:@" | "];
            }
            if (_detailModel.priceText.length > 0) {
                [string appendString:_detailModel.priceText];
            }
            
            _formatterLabel.text = [NSString stringWithFormat:@"鉴定结论：%@",string];
            _messageLabel.text = _detailModel.pingyu;
            _sourceLabel.text = _detailModel.resultSource;
        }
        else
        {
            NSMutableString *string = [NSMutableString string];
            if (_detailModel.statusName.length > 0) {
                [string appendString:_detailModel.topictitle];
                [string appendString:@" | "];
            }
            if (_detailModel.catetypeName.length > 0) {
                [string appendString:_detailModel.catetypeName];
                [string appendString:@" | "];
            }
            if (_detailModel.catetypeName.length > 0) {
                [string appendString:_detailModel.statusName];
            }
            _formatterLabel.text = string;
            _messageLabel.text = _detailModel.message;
            _sourceLabel.text = _detailModel.sourceText;
        }
        
        //_viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        CGSize titleSize = [_formatterLabel sizeThatFits:CGSizeMake(self.contentView.frame.size.width - SPACE * 2, CGFLOAT_MAX)];
        _formatterLabel.frame = CGRectMake(SPACE, SPACE, titleSize.width, titleSize.height);
        CGSize subtitleSize = [_subtitleLabel sizeThatFits:CGSizeMake(self.contentView.frame.size.width - SPACE * 2, CGFLOAT_MAX)];
        _messageLabel.frame = CGRectMake(SPACE, _formatterLabel.bottom + SPACE, subtitleSize.width, subtitleSize.height);
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(self.contentView.frame.size.width - SPACE * 2, CGFLOAT_MAX)];
        _sourceLabel.frame = CGRectMake(SPACE, _messageLabel.bottom + 0, sourceSize.width, 0);
       // CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        //_viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _sourceLabel.top, viewSize.width, viewSize.height);
    } else if (_detailModel.topictype.integerValue == 4) {
        _titleLabel.hidden = NO;// 商品名
        _priceLabel.hidden = NO;// 价格
        _messageLabel.hidden = NO;// 内容
        _formatterLabel.hidden = NO;
        _sourceLabel.hidden = NO;
       // _viewLabel.hidden = NO;
        
        _titleLabel.text = _detailModel.firstTitle;
        if (_detailModel.lastTitle.length > 0) {
            _subtitleLabel.hidden = NO;
            _subtitleLabel.text = _detailModel.lastTitle;
        }
        if (_detailModel.sellPriceText.length > 0) {
            _priceLabel.text = [NSString stringWithFormat:@"价格：¥%.2f",[_detailModel.sellPriceText floatValue]/100];
        }
        _messageLabel.text = _detailModel.message;
        _formatterLabel.text = _detailModel.zuopinGuigeText;
        _sourceLabel.text = _detailModel.sourceText;
//        _viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _titleLabel.frame = CGRectMake(SPACE, SPACE, kScreenWidth-2*SPACE, titleSize.height);
        CGSize priceSize = [_priceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _priceLabel.frame = CGRectMake(SPACE, _titleLabel.endY + SPACE, kScreenW-2*SPACE, priceSize.height);
        if (_detailModel.lastTitle.length > 0) {
            CGSize subtitleSize = [_subtitleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _subtitleLabel.frame = CGRectMake(SPACE, _priceLabel.endY + SPACE, subtitleSize.width, subtitleSize.height);
            CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _messageLabel.frame = CGRectMake(SPACE, _subtitleLabel.endY + SPACE, messageSize.width, messageSize.height);
        } else {
            CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _messageLabel.frame = CGRectMake(SPACE, _priceLabel.bottom + SPACE, messageSize.width, messageSize.height);
        }
        CGSize formatSize = [_formatterLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _formatterLabel.frame = CGRectMake(SPACE, _messageLabel.bottom + SPACE, formatSize.width, formatSize.height);
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _sourceLabel.frame = CGRectMake(SPACE, _formatterLabel.bottom + 0, sourceSize.width, 0);
//        CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//        _viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _sourceLabel.top, viewSize.width, viewSize.height);
    } else if (_detailModel.topictype.integerValue == 6 ||
               _detailModel.topictype.integerValue == 8) {
        _titleLabel.hidden = NO;
        _messageLabel.hidden = NO;
        _formatterLabel.hidden = NO;
        _sourceLabel.hidden = NO;
       // _viewLabel.hidden = NO;
        
        _titleLabel.text = _detailModel.firstTitle;
        if (_detailModel.lastTitle.length > 0) {
            _subtitleLabel.hidden = NO;
            _subtitleLabel.text = _detailModel.lastTitle;
        }
        
        NSMutableString *string = [NSMutableString string];
        if (_detailModel.topictype.integerValue == 6) {
            if (_detailModel.ageText.length > 0) {
                [string appendString:_detailModel.ageText];
                [string appendString:@" | "];
            }
            if (_detailModel.zuopinGuigeText.length > 0) {
                [string appendString:_detailModel.zuopinGuigeText];
                [string appendString:@" | "];
            }
            if (_detailModel.caizhi.length > 0) {
                [string appendString:_detailModel.caizhi];
            }
        } else if (_detailModel.topictype.integerValue == 8) {
            if (_detailModel.starttime.length > 0) {
                [string appendString:_detailModel.starttime];
                [string appendString:@" | "];
            }
            if (_detailModel.city.length > 0) {
                [string appendString:_detailModel.city];
                [string appendString:@" | "];
            }
            if (_detailModel.address.length > 0) {
                [string appendString:_detailModel.address];
                [string appendString:@" | "];
            }
            if (_detailModel.planner.length > 0) {
                [string appendString:_detailModel.planner];
            }
        }
        
        _formatterLabel.text = string;
        _messageLabel.text = _detailModel.message;
        _sourceLabel.text = _detailModel.sourceText;
        //_viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _titleLabel.frame = CGRectMake(SPACE, SPACE, kScreenW, titleSize.height);
        if (_detailModel.lastTitle.length > 0) {
            CGSize subtitleSize = [_subtitleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _subtitleLabel.frame = CGRectMake(SPACE, _titleLabel.bottom + SPACE, subtitleSize.width, subtitleSize.height);
            CGSize formatSize = [_formatterLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _formatterLabel.frame = CGRectMake(SPACE, _subtitleLabel.bottom + SPACE, formatSize.width, formatSize.height);
        } else {
            CGSize formatSize = [_formatterLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _formatterLabel.frame = CGRectMake(SPACE, _titleLabel.bottom + SPACE, formatSize.width, formatSize.height);
        }
        CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _messageLabel.frame = CGRectMake(SPACE, _formatterLabel.bottom + SPACE, messageSize.width, messageSize.height);
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _sourceLabel.frame = CGRectMake(SPACE, _messageLabel.bottom + 0, sourceSize.width, 0);
        //CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        //_viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _sourceLabel.top, viewSize.width, viewSize.height);
    } else if (_detailModel.topictype.integerValue == 9) {
        //self.titleLabel.hidden = NO;
        //self.formatterLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        self.messageLabel.hidden = NO;
        self.sourceLabel.hidden = NO;
        //_viewLabel.hidden = NO;
        
        self.titleLabel.text = _detailModel.firstTitle;
        if (_detailModel.lastTitle.length > 0) {
            self.subtitleLabel.text = _detailModel.lastTitle;
            self.subtitleLabel.hidden = NO;
        }
        
        if (_detailModel.peopleUserName.length > 0) {
            self.formatterLabel.text = _detailModel.peopleUserName;
        }
        
        if (_detailModel.message.length > 0) {
            self.messageLabel.text = _detailModel.message;
        }
        
        if (_detailModel.age.length > 0) {
            self.priceLabel.text = _detailModel.age;
        }
        
        if (_detailModel.sourceText.length > 0) {
            self.sourceLabel.text = _detailModel.sourceText;
        }
        
//        _viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _titleLabel.frame = CGRectMake(SPACE, 0, kScreenW, 0);
        if (_detailModel.lastTitle.length > 0) {
            CGSize subtitleSize = [_subtitleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _subtitleLabel.frame = CGRectMake(SPACE, _titleLabel.bottom + SPACE, subtitleSize.width, subtitleSize.height);
            CGSize formatSize = [_formatterLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _formatterLabel.frame = CGRectMake(SPACE, _subtitleLabel.bottom + SPACE, formatSize.width, 0);
        } else {
            CGSize formatSize = [_formatterLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _formatterLabel.frame = CGRectMake(SPACE, _titleLabel.bottom + 0, formatSize.width, 0);
        }
        CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _messageLabel.frame = CGRectMake(SPACE, _formatterLabel.bottom + SPACE, messageSize.width, messageSize.height);
        _messageLabel.font = ART_FONT(ARTFONT_OFI);
        CGSize priceSize = [_priceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _priceLabel.frame = CGRectMake(SPACE, _messageLabel.bottom + SPACE, priceSize.width, priceSize.height);
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _sourceLabel.frame = CGRectMake(SPACE, _priceLabel.bottom + 0, sourceSize.width, 0);
//        CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//        _viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _sourceLabel.top, viewSize.width, viewSize.height);
    } else if (_detailModel.topictype.integerValue == 14) {
        _messageLabel.hidden = NO;
        _sourceLabel.hidden = NO;
        //_viewLabel.hidden = NO;
        
        NSMutableString *string = [NSMutableString string];
        if (_detailModel.age.length > 0) {
            [string appendString:_detailModel.age];
            [string appendString:@" | "];
        }
        if (_detailModel.topictitle.length > 0) {
            [string appendString:_detailModel.topictitle];
            [string appendString:@" | "];
        }
        if (_detailModel.award.length > 0) {
            [string appendString:_detailModel.award];
            [string appendString:@" | "];
        }
        if (_detailModel.message.length > 0) {
            [string appendFormat:@"获奖作品：%@",_detailModel.message];
        }
        _messageLabel.text = string;
        
        self.sourceLabel.text = _detailModel.sourceText;
        //_viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _messageLabel.frame = CGRectMake(SPACE, SPACE, messageSize.width, messageSize.height);
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _sourceLabel.frame = CGRectMake(SPACE, _messageLabel.bottom + 0, sourceSize.width, 0);
        //CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        //_viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _sourceLabel.top, viewSize.width, viewSize.height);
    } else if (_detailModel.topictype.integerValue == 15 ||
               _detailModel.topictype.integerValue == 16) {
        _formatterLabel.hidden = NO;
        _messageLabel.hidden = NO;
        _sourceLabel.hidden = NO;
        //_viewLabel.hidden = NO;
        
        NSMutableString *string = [[NSMutableString alloc] init];
        if (_detailModel.age.length > 0) {
            [string appendString:_detailModel.age];
            [string appendString:@" | "];
        }
        if (_detailModel.sourceUserName.length > 0) {
            [string appendString:_detailModel.sourceUserName];
        }
        
        //_viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        self.formatterLabel.text = string;
        
        self.messageLabel.text = [NSString stringWithFormat:@"作品：%@",_detailModel.message];
        
        self.sourceLabel.text = _detailModel.sourceText;
        
        CGSize formatSize = [_formatterLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        self.formatterLabel.frame = CGRectMake(SPACE, SPACE, formatSize.width, formatSize.height);
        
        CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        self.messageLabel.frame = CGRectMake(SPACE, _formatterLabel.bottom + SPACE, messageSize.width, messageSize.height);
        
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        self.sourceLabel.frame = CGRectMake(SPACE, _messageLabel.bottom + SPACE, sourceSize.width, sourceSize.height);
        //CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        //_viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _sourceLabel.top, viewSize.width, viewSize.height);
    } else if (_detailModel.topictype.integerValue == 17) {
        _titleLabel.hidden = NO;
        _messageLabel.hidden = NO;
        _formatterLabel.hidden = NO;
        _sourceLabel.hidden = NO;
        _webView.hidden = NO;
        //_viewLabel.hidden = NO;
        
        self.titleLabel.text = _detailModel.firstTitle;
        if (_detailModel.lastTitle.length > 0) {
            self.subtitleLabel.hidden = NO;
            self.subtitleLabel.text = _detailModel.lastTitle;
        }
        
        //_viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        _messageLabel.text = [NSString stringWithFormat:@"来源%@",_detailModel.sourceUserName];
        
        NSURL *URL = [NSURL URLWithString:_detailModel.message];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        if (![self.webView.request.URL.absoluteString containsString:URL.absoluteString]) {
            [self.webView loadRequest:request];
        }
        
        _formatterLabel.text = _detailModel.age;
        _sourceLabel.text = _detailModel.sourceText;
        
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _titleLabel.frame = CGRectMake(SPACE, SPACE, kScreenW, titleSize.height);
        if (_detailModel.lastTitle.length > 0) {
            CGSize subtitleSize = [_subtitleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _subtitleLabel.frame = CGRectMake(SPACE, _titleLabel.bottom + SPACE, subtitleSize.width, subtitleSize.height);
            CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _messageLabel.frame = CGRectMake(SPACE, _subtitleLabel.bottom + SPACE, messageSize.width, messageSize.height);
        } else {
            _messageLabel.frame = CGRectMake(SPACE, _titleLabel.bottom + SPACE, contentWidth, 10);
        }
        _webView.frame = CGRectMake(SPACE, _messageLabel.bottom + SPACE, contentWidth, 10);
        CGSize formatSize = [_formatterLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        self.formatterLabel.frame = CGRectMake(SPACE, _webView.bottom + SPACE, formatSize.width, formatSize.height);
        
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        self.sourceLabel.frame = CGRectMake(SPACE, _formatterLabel.bottom + SPACE, sourceSize.width, sourceSize.height);
        //CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        //_viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _sourceLabel.top, viewSize.width, viewSize.height);
    } else if (_detailModel.topictype.integerValue == 18) {
        _titleLabel.hidden = NO;
        _messageLabel.hidden = NO;
        _sourceLabel.hidden = NO;
        //_viewLabel.hidden = NO;
        
        self.titleLabel.text = _detailModel.firstTitle;
        if (_detailModel.lastTitle.length > 0) {
            self.subtitleLabel.hidden = NO;
            self.subtitleLabel.text = _detailModel.lastTitle;
        }
        
        NSMutableString *string = [[NSMutableString alloc] init];
        if (_detailModel.age.length > 0) {
            [string appendString:_detailModel.age];
            [string appendString:@" | "];
        }
        if (_detailModel.message.length > 0) {
            [string appendString:_detailModel.message];
        }
        
        self.messageLabel.text = string;
        self.sourceLabel.text = _detailModel.sourceText;
        //_viewLabel.text = [NSString stringWithFormat:@"%@浏览",_detailModel.clicknum];
        
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        _titleLabel.frame = CGRectMake(SPACE, SPACE, kScreenW, titleSize.height);
        if (_detailModel.lastTitle.length > 0) {
            CGSize subtitleSize = [_subtitleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _subtitleLabel.frame = CGRectMake(SPACE, _titleLabel.bottom + SPACE, subtitleSize.width, subtitleSize.height);
            CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _messageLabel.frame = CGRectMake(SPACE, _subtitleLabel.bottom + SPACE, messageSize.width, messageSize.height);
        } else {
            CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
            _messageLabel.frame = CGRectMake(SPACE, _titleLabel.bottom + SPACE, messageSize.width, messageSize.height);
        }
        CGSize sourceSize = [_sourceLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        self.sourceLabel.frame = CGRectMake(SPACE, _messageLabel.bottom + SPACE, sourceSize.width, sourceSize.height);
        //CGSize viewSize = [_viewLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        //_viewLabel.frame = CGRectMake(self.contentView.frame.size.width - SPACE - viewSize.width, _sourceLabel.top, viewSize.width, viewSize.height);
    }
}



#pragma mark - Getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ART_FONT(ARTFONT_TZ);//20
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = ART_FONT(ARTFONT_OFI);
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_subtitleLabel];
    }
    return _subtitleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = ART_FONT(ARTFONT_OFI);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)formatterLabel
{
    if (!_formatterLabel) {
        _formatterLabel = [[UILabel alloc] init];
        _formatterLabel.font = ART_FONT(ARTFONT_OFI);
        _formatterLabel.numberOfLines = 0;
        [self.contentView addSubview:_formatterLabel];
    }
    return _formatterLabel;
}

- (UITextView *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UITextView alloc] init];
        
        _messageLabel.font = ART_FONT(ARTFONT_OFI);
        //_messageLabel.numberOfLines = 0;
        [self.contentView addSubview:_messageLabel];
       //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) name:UIMenuControllerWillShowMenuNotification object:nil];
    }
    return _messageLabel;
}
//- (void)dealloc{
//    // 移除监听通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//-(void)show:(NSNotificationName*)name{
//    //[_messageLabel resignFirstResponder];
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏
//}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self.contentView addSubview:_webView];
    }
    return _webView;
}

- (UILabel *)sourceLabel
{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.font = ART_FONT(ARTFONT_OFI);
        _sourceLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_sourceLabel];
    }
    return _sourceLabel;
}

- (UIImageView *)flagImageView
{
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc] init];
        [_flagImageView setImage:[UIImage imageNamed:@"image_jianding"]];
        [self.contentView addSubview:_flagImageView];
        
        [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SPACE);
            make.top.mas_equalTo(0);
        }];
    }
    return _flagImageView;
}

//- (UILabel *)viewLabel
//{
//    if (!_viewLabel) {
//        _viewLabel = [[UILabel alloc] init];
//        _viewLabel.font = ART_FONT(ARTFONT_OFI);
//        _viewLabel.textColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:_viewLabel];
//        
//        UIImageView *viewImage = [[UIImageView alloc] init];
//        viewImage.clipsToBounds = YES;
//        viewImage.image = [UIImage imageNamed:@"view_num"];
//        [self.contentView addSubview:viewImage];
//        [viewImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(_viewLabel.mas_left).offset(-SPACE/2);
//            make.centerY.mas_equalTo(_viewLabel);
//        }];
//    }
//    return _viewLabel;
//}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewHeightDidChangeOnTopicDetail" object:@(height)];
}

- (void)setDetailModel:(CangyouQuanDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
