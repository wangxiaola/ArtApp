
//
//  MemberAreaCollectionViewCell.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MemberAreaCollectionViewCell.h"
#define UPANDBOTTOMSPACE 20
#define BUTTONHEIGHT 30
#define MINIMUNSPACE 15

#define UNSELECTEDWIDTH (SCREEN_WIDTH - 2* MINIMUNSPACE)
#define UNSELECTEDHEIGHT (UNSELECTEDWIDTH * 24 / 61.0)

@interface MemberAreaCollectionViewCell()

@property (nonatomic, strong)UIView *categoryView;
@property (nonatomic, assign)CGFloat bottomViewHeight;
//@property (nonatomic, strong)UIImageView *bottomImageView;

@end

@implementation MemberAreaCollectionViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.categoryView = [[UIView alloc]init];
        [self.contentView addSubview:self.categoryView];
        
        self.isDisplayCategory = NO;
    }
    return self;
}



- (UIImageView *)imageView{
    if (!_imageview) {
        
        _imageview = [[UIImageView alloc] init];
        _imageview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_imageview];
        
        [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(MINIMUNSPACE);
            make.right.mas_offset(-MINIMUNSPACE);
            make.height.mas_equalTo(UNSELECTEDHEIGHT - MINIMUNSPACE);
        }];

    }
    return _imageview;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(MINIMUNSPACE);
            make.right.mas_offset(-MINIMUNSPACE);
            make.height.mas_equalTo(UNSELECTEDHEIGHT  - MINIMUNSPACE);
        }];
        
    }
    return _titleLabel;
}



-(void)setGoodsCategory:(NSArray<GoodsCategoryModel *> *)goodsCategory{
    
    _goodsCategory = goodsCategory;
    if (goodsCategory.count) {
        
        if (self.categoryView.subviews.count) {
            [self.categoryView removeAllSubviews];
        }
        [self.contentView bringSubviewToFront:self.categoryView];
        
        //背景带尖的imageView
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"upArrowImage"];
        
        [self.categoryView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.categoryView);
        }];

        
        NSInteger column;
        column = (goodsCategory.count % 2) ? (goodsCategory.count / 2 + 1) : (goodsCategory.count / 2 );
        self.bottomViewHeight = UPANDBOTTOMSPACE * 2 + column * BUTTONHEIGHT;
        
        [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(self.bottomViewHeight);
        }];
        
        //view上显示分类的button
        CGFloat width = kScreenW / 2.0;
        for (int i = 0; i < goodsCategory.count;  i ++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(width * ( i % 2 ), UPANDBOTTOMSPACE + (i / 2) * BUTTONHEIGHT, width, BUTTONHEIGHT)];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.tag = 100 + i;
            [button setTitle:goodsCategory[i].title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.categoryView addSubview:button];
        }
        
    }
}

-(void)categoryClick:(UIButton *)button{
    
    NSInteger tag = button.tag;
    
    self.callBackBlock(self.goodsCategory[tag - 100]);//-10 是为了让 image 上的尖向上移
}

-(void)setIsDisplayCategory:(BOOL)isDisplayCategory{
    _isDisplayCategory = isDisplayCategory;
}


-(void)setImageView:(NSString *)imageUrl titileLabelText:(NSString *)titileLabelText isDisplayCategory:(BOOL)isDisplayCategory goodsCategory:(NSArray *)goodsCategory clickCategoryCallBackBlock:(CallBackBlock)CallBackBlock{
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.titleLabel.text = titileLabelText;
    
    self.isDisplayCategory = isDisplayCategory;
    
    //判断是否显示view
    if(_isDisplayCategory){
        
        self.goodsCategory = goodsCategory;
    }else{
        if (self.categoryView != nil) {
            [self.categoryView removeFromSuperview];
            self.categoryView = nil;
        }
        self.bottomViewHeight = 0;
    }
    self.callBackBlock = CallBackBlock;
}


@end
