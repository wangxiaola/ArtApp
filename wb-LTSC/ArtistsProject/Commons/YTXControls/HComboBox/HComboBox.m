//
//  HLabelWithTitle.m
//  HUIKitLib
//
//  Created by by Heliulin on 15/6/1.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//
#import "HControls.h"
#import "HSingleCategoryChoiceVC.h"
#import "UIViewController+KNSemiModal.h"
#import "ListResultModel.h"

@interface HComboBox ()

@property(nonatomic,strong) HLabel *labelTitle;
@property(nonatomic,strong) HLabel *labelContent;
@property(nonatomic,strong) UIImageView *imgArr;

@end

@implementation HComboBox
@synthesize labelTitle;
@synthesize labelContent;

- (id) init
{
    self=[super init];
    if (self){
        [self customInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self){
        [self customInit];
    }
    return self;
}

- (void) customInit
{
    self.titleWidth=110;
    self.titleAlignment=NSTextAlignmentRight;
    self.titleColor=kTitleColor;
    self.titleFont=[UIFont systemFontOfSize:15];
    
    self.contentColor=kSubTitleColor;
    self.contentFont=[UIFont systemFontOfSize:15];
    
    labelTitle=[HLabel new];
    [self addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.and.bottom.equalTo(self);
        make.width.mas_equalTo(self.titleWidth);
    }];
    [labelTitle setFont:self.titleFont];
    [labelTitle setTextColor:self.titleColor];
    [labelTitle setTextAlignment:self.titleAlignment];
    
    
    self.imgArr=[UIImageView new];
    [self addSubview:self.imgArr];
    [self.imgArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    
    labelContent=[HLabel new];
    [self addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right);
        make.top.and.bottom.equalTo(self);
        make.right.equalTo(self.imgArr.mas_left).offset(-5);
    }];
    [labelContent setTextColor:self.contentColor];
    [labelContent setFont:self.contentFont];
    [labelContent setTextAlignment:NSTextAlignmentLeft];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void) tap
{
    if (self.tapBlock){
        self.tapBlock(self);
    }else{
        if (self.items==nil||self.items.count==0){
//            NSDictionary* dict = @{ @"id" : self.categoryID,
//                                    @"pageno" : @"1",
//                                    @"pagesize" : @"1000" };
//            HHttpRequest* request = [[HHttpRequest alloc] init];
//            [request httpRequestWithModuleName:@"Category"
//                               andActionName:@"getCategory"
//                                 andPramater:dict
//                        andDidDataErrorBlock:nil
//                   andDidRequestSuccessBlock:^(AFHTTPRequestOperation* operation, id responseObject) {
//                       ListResultModel* result = [ListResultModel objectWithKeyValues:responseObject];
//                       self.items = [[NSMutableArray alloc] initWithCapacity:0];
//                       for (NSDictionary* dic in result.data.datalist) {
//                           [self.items addObject:[[HKeyValuePair alloc] initWithValue:[NSString stringWithFormat:@"%@",dic[@"id"]] andDisplayText:dic[@"categoryName"]]];
//                       }
//                       [self showDropDownListVC:self.items];
//                   }
//                    andDidRequestFailedBlock:nil];
        }else{
            [self showDropDownListVC:self.items];
        }
    }
}
- (void) showDropDownListVC:(NSMutableArray*)items
{
    HSingleCategoryChoiceVC *dropDownListVC=[[HSingleCategoryChoiceVC alloc] init];
    dropDownListVC.allowMultiChoice=self.allowMultiChoice;
    dropDownListVC.items=items;
    dropDownListVC.navTitle=self.placeHolder;
    dropDownListVC.numberOfColumns=self.numberOfColumns;
    dropDownListVC.selectedValues=self.selectedValues;
    dropDownListVC.disabledClear=YES;
    [dropDownListVC setFinishSelectedBlock:^(NSArray<HKeyValuePair*>* selectedItems){
        self.selectedItems=[[NSMutableArray alloc] initWithArray:selectedItems];
        
        self.content=[self.selectedDisplayTexts componentsJoinedByString:@"、"];
        if (self.selectionChangedBlock){
            self.selectionChangedBlock(self);
        }
    }];
    [dropDownListVC setClickedClearButtonBlock:^{
        self.selectedItems=[[NSMutableArray alloc] initWithCapacity:0];
        self.content=@"";
        NSLog(@"%@",self.selectedItems);
    }];
    
    UIViewController * parent = [self containingViewController];
    [parent presentSemiViewController:dropDownListVC
                          withOptions:@{ KNSemiModalOptionKeys.pushParentBack : @(NO) }];
}
- (void) setTitleWidth:(CGFloat)titleWidth
{
    _titleWidth=titleWidth;
    [self.labelTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
    }];
    [self.labelContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right);
    }];
}

- (void) setTitleAlignment:(NSTextAlignment)titleAlignment
{
    _titleAlignment=titleAlignment;
    [self.labelTitle setTextAlignment:titleAlignment];
    if (titleAlignment==NSTextAlignmentLeft){
        [self.labelTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.and.bottom.equalTo(self);
        }];
        
    }else{
        [self.labelTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.and.bottom.equalTo(self);
            make.width.mas_equalTo(self.titleWidth);
        }];
    }
    [self.labelContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right);
        make.top.and.bottom.equalTo(self);
        make.right.equalTo(self).offset(-25);
    }];
}
- (void) setContentAlignment:(NSTextAlignment)contentAlignment
{
    _contentAlignment=contentAlignment;
    self.labelContent.textAlignment=contentAlignment;
}
- (void) setTitle:(NSString *)title
{
    _title=title;
    if (self.isNecessary){
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" * %@",title]];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:kPriceColor
                              range:NSMakeRange(1, 1)];
        
        self.labelTitle.attributedText=AttributedStr;
    }else{
        self.labelTitle.text=title;
    }
}

- (void) setTitleColor:(UIColor *)titleColor
{
    _titleColor=titleColor;
    self.labelTitle.textColor=titleColor;
}

- (void) setTitleFont:(UIFont *)titleFont
{
    _titleFont=titleFont;
    [self.labelTitle setFont:titleFont];
}

- (void) setContent:(NSString *)content
{
    _content=content;
    self.labelContent.text=content;
    if ([content isEqualToString:@""]){
        self.labelContent.text=self.placeHolder;
    }
}

- (void) setContentColor:(UIColor *)contentColor
{
    _contentColor=contentColor;
    self.labelContent.textColor=contentColor;
}

- (void) setContentFont:(UIFont *)contentFont
{
    _contentFont=contentFont;
    [self.labelContent setFont:contentFont];
}
- (void) setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder=placeHolder;
    self.labelContent.text=self.placeHolder;
}
- (void) setSelectedItems:(NSMutableArray *)selectedItems
{
    _selectedItems=selectedItems;
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:0];
    for (HKeyValuePair *item in selectedItems) {
        if (!item) break;
        [arr addObject:item.displayText];
    }
    self.labelContent.text=[arr componentsJoinedByString:@"-"];
}
- (NSMutableArray*) selectedValues
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:0];
    for (HKeyValuePair *item in self.selectedItems) {
        if (!item) break;
        [arr addObject:item.value];
    }
    return arr;
}
- (NSMutableArray*) selectedDisplayTexts
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:0];
    for (HKeyValuePair *item in self.selectedItems) {
        if (!item) break;
        [arr addObject:item.displayText];
    }
    return arr;
}

- (void) setHiddenContent:(BOOL)hiddenContent
{
    _hiddenContent=hiddenContent;
    self.imgArr.hidden=hiddenContent;
    labelContent.hidden=hiddenContent;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.isBlank){
        [self.imgArr setImage:[UIImage imageNamed:@"icon_HComboBox_right"]];
    }else{
        [self.imgArr setImage:[UIImage imageNamed:@"icon_HComboBox_down"]];
    }
}
@end