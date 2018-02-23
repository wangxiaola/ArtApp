//
//  KaiShiJiandingVC.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "KaiShiJiandingVC.h"
#import "CangPinKuCell.h"
#import "HomeListDetailVc.h"

@interface KaiShiJiandingVC ()

@end

@implementation KaiShiJiandingVC

-(void)viewWillAppear:(BOOL)animated{
    self.actionName=@"topiclist";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"cuid":[Global sharedInstance].userID?:@"0",@"status": @"4",@"catatype":[NSString stringWithFormat:@"%@",[Global sharedInstance].auth]}];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [super viewWillAppear:animated];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"待鉴定藏品";
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [self.flowLayout setItemSize:CGSizeMake((kScreenW-30)/2, (kScreenW-30)/2 + 40)];//设置cell的尺寸
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//设置其边界
    self.flowLayout.minimumInteritemSpacing=1;
    self.flowLayout.minimumLineSpacing=1;
    
    [self.collection setBackgroundColor:[UIColor whiteColor]];
    [self.collection registerClass:[CangPinKuCell class] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
    
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CangPinKuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewIdentifier" forIndexPath:indexPath];
    if (!cell){
        cell=[[CangPinKuCell alloc] initWithFrame:CGRectMake(0, 0, (kScreenW-30)/2, (kScreenW-30)/2)];
    }
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel objectWithKeyValues:self.lstData[indexPath.row]];
    cell.model=model;
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
   
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",model.id];
    detailVC.topictype = [NSString stringWithFormat:@"%@",model.topictype];
    [self.navigationController pushViewController:detailVC animated:YES];

}

@end
