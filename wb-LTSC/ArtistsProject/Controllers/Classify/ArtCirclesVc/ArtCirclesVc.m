//
//  ArtCirclesVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/15.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtCirclesVc.h"
#import "CirclesHeadCell.h"
#import "CirclesImageCell.h"
#import "CirclesBtnCell.h"
#import "CirclesCell.h"
#import "PublishDongtaiVC.h"

@interface ArtCirclesVc ()<UITextFieldDelegate>
{
    CirclesHeadCell* _headCell;
    CirclesImageCell* _imgCell;
    CirclesCell* _titleCell;
}
@property(nonatomic,strong)NSMutableArray* mutArr;
@property(nonatomic,strong)UITextField* commentField;
@end

@implementation ArtCirclesVc
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)createView{
    [super createView];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //自定义线条
//    UIImageView *line1=[[UIImageView alloc]init];
//    line1.backgroundColor=Art_LineColor;
//    [self.view addSubview:line1];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(Art_Line_HEIGHT);
//        make.top.equalTo(self.view.mas_top).offset(0);
//    }];

    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0.5, 0, 0, 0));
    }];
    //导航右侧3个按钮
   
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 105, 40)];
    UIButton *itmeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itmeButton.frame = CGRectMake((28+5)*2+15,4, 35, 35);
    [itmeButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [itmeButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [itmeButton  setImage:[UIImage imageNamed:@"homePush"] forState:UIControlStateNormal];
    [rightButton addSubview:itmeButton];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = barItem;

    
    
    if ([self.acStr isEqualToString:@"liketopiclist"]) {
        NSDictionary * dict = @{
                                
                                @"uid":self.artId?self.artId:@"0",
                                @"num":@"10"
                                };
        [self.dataDic addEntriesFromDictionary:dict];

    }else{
    NSDictionary * dict = @{@"artist":@"1",
                            @"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",
                            @"num":@"10"
                            };
    [self.dataDic addEntriesFromDictionary:dict];
    }
    _mutArr = [[NSMutableArray alloc]init];
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
}

-(void)loadMoreData{
    self.pageIndex++;
    [self loadData];
}

-(void)refreshData{
    self.pageIndex = 1;
    [self loadData];
}
-(void)loadAgain{
    [self.dataDic setObject:[NSString stringWithFormat:@"%ld",self.pageIndex] forKey:@"page"];

    __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:self.acStr andPramater:self.dataDic succeeded:^(id responseObject) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [self.hudLoading hideAnimated:YES];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.pageIndex==1){
                [_mutArr removeAllObjects];
            }
            [_mutArr addObjectsFromArray:responseObject];
            
            [self.tabView.mj_header endRefreshing];
            [self.tabView.mj_footer endRefreshing];
           
        }else{
            if (strongSelf.pageIndex==1){//没有相关数据
            //[strongSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
                [_mutArr removeAllObjects];
                [weakSelf.tabView.mj_header endRefreshing];
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];

            }else{//没有更多数据
               [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tabView reloadData];
    } failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [strongSelf.tabView.mj_header endRefreshing];
        [strongSelf.tabView.mj_footer endRefreshing];

        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
        
    }];

}
-(void)loadData{
    
    [self.dataDic setObject:[NSString stringWithFormat:@"%ld",self.pageIndex] forKey:@"page"];
       __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:self.acStr andPramater:self.dataDic succeeded:^(id responseObject) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [self.hudLoading hideAnimated:YES];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.pageIndex==1){
                [_mutArr removeAllObjects];
            }
            [_mutArr addObjectsFromArray:responseObject];
            [self.tabView.mj_header endRefreshing];
            [self.tabView.mj_footer endRefreshing];
            
        }else{
            if (strongSelf.pageIndex==1){//没有相关数据
              //  [strongSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
                [_mutArr removeAllObjects];
                [weakSelf.tabView.mj_header endRefreshing];
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];

            }else{//没有更多数据
               [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tabView reloadData];
       
    } failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [strongSelf.tabView.mj_header endRefreshing];
        [strongSelf.tabView.mj_footer endRefreshing];

        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mutArr.count>0?_mutArr.count:0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            if (_headCell){
                NSDictionary* dic = _mutArr[indexPath.section];
                height = [_headCell setCirclesHeadCellDicValue:dic];
            }

            break;
        case 1:
            
            if (_imgCell){
                NSDictionary* dic = _mutArr[indexPath.section];
             height =   [_imgCell setCirclesImagesCellDicValue:dic];
            }
            break;
        case 2:
            height = T_WIDTH(40);
            
            break;
        case 3:
            
            if (_titleCell){
                NSDictionary* dic = _mutArr[indexPath.section];
                if (dic.count>0) {
                    height =  [_titleCell setArtTableViewCellDicValue:dic];
                }
              
            }
            break;
            
        default:
            break;
    }
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==0) {
        CirclesHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CirclesHeadCell"];
        if (cell==nil){
            cell = [[CirclesHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CirclesHeadCell"];
        }
        if (self.obj) {
            cell.baseViews = self.view;
        }
        
        __weak typeof(cell)weakImgCell = cell;
        _headCell = weakImgCell;
        return cell;
    }else if(indexPath.row==1) {
        CirclesImageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CirclesImageCell"];
        if (cell==nil){
            cell = [[CirclesImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CirclesImageCell"];
        }
        __weak typeof(cell)weakImgCell = cell;
        _imgCell = weakImgCell;
        return cell;
    }else if(indexPath.row==2){
        CirclesBtnCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CirclesBtnCell"];
        if (cell==nil){
            cell = [[CirclesBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CirclesBtnCell"];
        }
        NSDictionary* dic = _mutArr[indexPath.section];
        [cell setArtTableViewCellDicValue:dic];
        return cell;
    }else if(indexPath.row==3) {
        CirclesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CirclesCell"];
        if (cell==nil){
            cell = [[CirclesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CirclesCell"];
        }
        __weak typeof(cell)weakImgCell = cell;
        _titleCell = weakImgCell;
        return cell;
    }

    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CangyouQuanDetailModel* model = [CangyouQuanDetailModel mj_objectWithKeyValues:_mutArr[indexPath.section]];
    NSString* topicStr = model.topictype;
    if ([topicStr isEqualToString:@"17"]) {
        H5VC* h5 = [[H5VC alloc] init];
        h5.url = model.message;
        h5.hidesBottomBarWhenPushed = YES;
        if (self.obj) {
            [self.obj.navigationController pushViewController:h5 animated:YES];
        }else{
         [self.navigationController pushViewController:h5 animated:YES];
        }
    }else{

    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",model.id];
    detailVC.topictype = [NSString stringWithFormat:@"%@",model.topictype];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.isScrollToBottom = NO;
        if (self.obj) {
            [self.obj.navigationController pushViewController:detailVC animated:YES];
        }else{
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}
-(void)rightBtnClick{
    PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.topictype = @"7";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
