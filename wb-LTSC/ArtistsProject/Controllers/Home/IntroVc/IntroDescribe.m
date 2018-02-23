//
//  IntroDescribe.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "IntroDescribe.h"

@interface IntroDescribe ()
@property(nonatomic,strong)UITextView* describeView;
@end

@implementation IntroDescribe

-(void)addContentViews{
    _describeView = [[UITextView alloc]init];
    _describeView.editable = NO;
    _describeView.userInteractionEnabled = NO;
    _describeView.font = ART_FONT(ARTFONT_OFI);
    [self.contentView addSubview:_describeView];
    [_describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_offset(5);
        make.height.mas_equalTo(0);
    }];
}
-(CGFloat)heightWithContent:(NSString *)contentStr{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = T_WIDTH(5);// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:ART_FONT(ARTFONT_OF),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _describeView.attributedText = [[NSAttributedString alloc] initWithString:contentStr attributes:attributes];
    
// CGFloat height = [self heightForTextView:_describeView];
    CGSize size =  [_describeView sizeThatFits:CGSizeMake(SCREEN_WIDTH-30, 100)];
    
    [_describeView mas_updateConstraints:^(MASConstraintMaker *make){
        if (!(contentStr.length>0)) {
           make.height.mas_equalTo(0);
        }else{
         make.height.mas_equalTo(size.height);
        }
    }];
    
    return contentStr.length>0?size.height+10:0;
}
-(float)heightForTextView:(UITextView *)textView {
    float fPadding = 8.0;
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding*2 - 30*2, MAXFLOAT);
    CGRect rect = [textView.text boundingRectWithSize:constraint options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil];
    float fHeight = rect.size.height + 16.0;
    return fHeight;
}

@end
