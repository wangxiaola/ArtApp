//
//  IntroVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MediaVc.h"
#define SECTION_NUMS 2
#define SECTION_FIRST 0//icon
#define SECTION_SECOND 1//

#define ICON_CELL_HEIGHT T_WIDTH(100)

#import "MediaFirstCell.h"
#import "MediaSecondCell.h"
#import "H5VC.h"

@interface MediaVc ()
{
    MediaSecondCell* _tempCell;
}
@property(nonatomic,strong)NSMutableArray * userlogoArray;
@property(nonatomic,strong)NSMutableArray * listArray;
@end

@implementation MediaVc
-(void)createView{
    [super createView];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabView.hidden = YES;
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _tempCell = [[MediaSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MediaSecondCell"];

    _userlogoArray = [[NSMutableArray alloc]init];
    _listArray = [[NSMutableArray alloc]init];
    NSDictionary * dict = @{@"postuid":self.artId?self.artId:@"0",
                            @"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",
                            @"num":@"10",
                            @"groupsel":@"1",
                            @"topictype":@"17"
                            };
    [self.dataDic addEntriesFromDictionary:dict];
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
}
- (void)loadMoreData{
    self.pageIndex++;
    [self loadData];
}
- (void)refreshData{
    self.pageIndex = 1;
    [self loadData];
}
- (void)loadData{
    NSString* pageStr = [NSString stringWithFormat:@"%ld",self.pageIndex];
    [self.dataDic setObject:pageStr forKey:@"page"];
    
    __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:@"topiclist" andPramater:self.dataDic succeeded:^(id responseObject) {
//        kPrintLog(responseObject);
        [weakSelf.hudLoading hideAnimated:YES];
//        [_userlogoArray removeAllObjects];
//        [_userlogoArray addObjectsFromArray:responseObject[@"mtlogo"]];
//        [_userlogoArray addObjectsFromArray:responseObject];

//        id obj = responseObject[@"mtgz"][@"info"];
        id obj = responseObject;

        if ([obj isKindOfClass:[NSArray class]]) {
            //媒体
            if (weakSelf.pageIndex==1){
                [_listArray removeAllObjects];
            }
//            [_listArray addObjectsFromArray:responseObject[@"mtgz"][@"info"]];
            [_listArray addObjectsFromArray:responseObject];
            [weakSelf.tabView.mj_header endRefreshing];
            [weakSelf.tabView.mj_footer endRefreshing];

            kPrintLog(_listArray);
        }else{
            //没有更多数据
            [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
        }
        
        weakSelf.tabView.hidden = NO;
        [weakSelf.tabView reloadData];
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section==SECTION_FIRST) {
//        return _userlogoArray.count>0?1:0;;
//    }else if (section==SECTION_SECOND){
        return _listArray.count>0?_listArray.count:0;
//    }
//    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==SECTION_FIRST){
//        return ICON_CELL_HEIGHT;
//    }else if (indexPath.section==0){
        if (_tempCell){
            NSDictionary* dic = _listArray[indexPath.row];
            return  [_tempCell setMediaCellDicValue:dic];
        }
//    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==SECTION_FIRST) {
//        MediaFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MediaFirstCell"];
//        if (cell==nil) {
//            cell = [[MediaFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MediaFirstCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, ICON_CELL_HEIGHT)];
//        }
//        [cell setArtTableViewCellArrValue:_userlogoArray];
//        return cell;
//    }else if (indexPath.section==SECTION_SECOND){
    if (indexPath.row == 0) {
        kPrintLog(@"0");
    }if (indexPath.row == 1) {
        kPrintLog(@"1");
    }
        MediaSecondCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MediaSecondCell"];
        if (cell==nil) {
            cell = [[MediaSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MediaSecondCell"];
        }
        __weak typeof(cell)weakCell = cell;
        _tempCell = weakCell;
        return cell;
//    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section>0){
        NSDictionary* dic = _listArray[indexPath.row];
        H5VC* h5 = [[H5VC alloc] init];
        h5.navTitle = dic[@"topictitle"];
        h5.url = dic[@"message"];
        h5.hidesBottomBarWhenPushed = YES;
        [self.view.containingViewController.navigationController pushViewController:h5 animated:YES];
//    }
}


@end
