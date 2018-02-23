//
//  IntroImageCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "LikeUsersCell.h"
#import "TextsFirstCollectionCell.h"
#import "sendBtn.h"

@interface LikeUsersCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UIImageView* zanImg;
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)sendBtn* chkDefault;
@property(nonatomic,strong)NSMutableArray* imageArr;
@property(nonatomic,strong)UIButton* btnZan;
@property(nonatomic,strong)NSMutableDictionary* likeDict;
@end

@implementation LikeUsersCell
-(void)addContentViews{
    self.contentView.backgroundColor = BACK_VIEW_COLOR;
    //赞
     _btnZan = [[UIButton alloc]init];
    _btnZan.frame = CGRectMake(15, 5, 30, 50);
    [_btnZan addTarget:self action:@selector(btnZan_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnZan setImage:[UIImage imageNamed:@"未赞"] forState:UIControlStateNormal];
    [_btnZan setImage:[UIImage imageNamed:@"已赞"] forState:UIControlStateSelected];
    [self.contentView addSubview:_btnZan];
    
    
    _imageArr = [[NSMutableArray alloc]init];
    //创建网格布局对象
    UICollectionViewFlowLayout* lay = [[UICollectionViewFlowLayout alloc]init];
    lay.itemSize = CGSizeMake(30, 30);//cell大小
    lay.sectionInset = UIEdgeInsetsMake(0,5, 0, 5);
    lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
    lay.minimumLineSpacing = 10;//行间距
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(getViewWidth(_btnZan)+15,15,self.bounds.size.width-120,30) collectionViewLayout:lay];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=BACK_VIEW_COLOR;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[TextsFirstCollectionCell class] forCellWithReuseIdentifier:@"TextsFirstCollectionCell"];
    [self.contentView addSubview:self.collectionView];
    
    _chkDefault = [[sendBtn alloc] init];
    _chkDefault.titleFrame = CGRectMake(0, 0, 25, 30);
    _chkDefault.imgFrame = CGRectMake(30, 10, 10, 10);
    [_chkDefault setImage:[UIImage imageNamed:@"icon_UserIndexVC_rightArrow"] forState:UIControlStateNormal];
    _chkDefault.titleLabel.textAlignment = NSTextAlignmentRight;
    [_chkDefault setTitle:@"" forState:UIControlStateNormal];
    [_chkDefault setTitleColor:kColor6 forState:UIControlStateNormal];
    [_chkDefault.titleLabel setFont:ART_FONT(ARTFONT_OT)];
    [_chkDefault addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
     [self.contentView addSubview:_chkDefault];
    
    [_chkDefault mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];

    _likeDict = [[NSMutableDictionary alloc]init];
}

-(void)detailClick{
    if (self.enterBtnClick){
        self.enterBtnClick();
    }
}

-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{
    [_likeDict removeAllObjects];
    [_likeDict addEntriesFromDictionary:dic];
    
    NSString* isLike = [NSString stringWithFormat:@"%@",dic[@"isLiked"]];
    if ([isLike isEqualToString:@"0"]) {
        _btnZan.selected = NO;
    }else{
        _btnZan.selected = YES;
    }
}
-(void)setArtTableViewCellArrValue:(NSArray *)arr{
    
    [_imageArr removeAllObjects];
    for (id obj in arr) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [_imageArr addObject:obj];
        }
    }
    [_chkDefault setTitle:[NSString stringWithFormat:@"%ld  ",_imageArr.count] forState:UIControlStateNormal];
    [self.collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageArr.count>0?_imageArr.count:0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //调用自定义Cell
    TextsFirstCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TextsFirstCollectionCell" forIndexPath:indexPath];
    id obj = _imageArr[indexPath.row];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        [cell setLikeCollectionViewCellValue:_imageArr[indexPath.row]];
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectImgCilck){
        self.selectImgCilck(_imageArr[indexPath.row]);
    }
}
-(void)btnZan_CLick:(UIButton*)send{
    if (![(BaseController*)self.contentView.containingViewController isNavLogin]) {
        return;
    }
    if (!_btnZan.selected){
        //NSLog(@"赞");
        [self Zan];
    }else{
        //NSLog(@"取消赞");
        [self cancelZan];
    }
}
////赞
- (void)Zan
{
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.containingViewController;
    
    NSString* topicidStr = [NSString stringWithFormat:@"%@",_likeDict[@"id"]];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID,
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"liketopic" andPramater:dict succeeded:^(id responseObject){
        
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"点赞" obj:responseObject]) {
            _btnZan.selected = YES;
            ScrollViewController* superView = (ScrollViewController*)self.contentView.containingViewController;

            if ([superView respondsToSelector:@selector(refreshData)]){
                [superView refreshData];
            }
        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [(BaseController*)self.contentView.containingViewController logonAgain];
                
            }
        }
        
    } failed:^(id responseObject) {
        [superView.hudLoading hideAnimated:YES];
    }];
}

//取消点赞
- (void)cancelZan
{
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.containingViewController;
    
   NSString* topicidStr = [NSString stringWithFormat:@"%@",_likeDict[@"id"]];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID,
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"delliketopic" andPramater:dict succeeded:^(id responseObject){
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"取消赞" obj:responseObject]) {
            _btnZan.selected = NO;
            ScrollViewController* superView = (ScrollViewController*)self.contentView.containingViewController;
            
            if ([superView respondsToSelector:@selector(refreshData)]){
                [superView refreshData];
            }
            
        }else{
            NSString* msg = responseObject[@"msg"];
            
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
               
                    [(BaseController*)self.contentView.containingViewController logonAgain];
            }
            
            
        }
        
    } failed:^(id responseObject) {
        [superView.hudLoading hideAnimated:YES];
    }];
}

@end
