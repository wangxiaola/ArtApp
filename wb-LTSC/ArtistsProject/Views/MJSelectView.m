//
//  MJSelectView.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MJSelectView.h"
#import "MJSelectCell.h"

@interface MJSelectView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* kindView;
@property(nonatomic,strong)NSMutableArray* kindArray;

@end

@implementation MJSelectView

-(instancetype)init{
    if (self=[super init]){
        _kindArray = [[NSMutableArray alloc]init];
        _kindView = [[UITableView alloc]init];
        _kindView.delegate = self;
        _kindView.dataSource = self;
        [self addSubview:_kindView];
    }
    return self;
}

-(void)showMJSelectViewWithTitleArr:(NSArray*)titleArr andFrame:(CGRect)frame
{
    [_kindArray removeAllObjects];
    [_kindArray addObjectsFromArray:titleArr];
    [KEY_WINDOW addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }];
    [_kindView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _kindArray.count>0?_kindArray.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MJSelectCell"];
    if (cell==nil) {
        cell = [[MJSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MJSelectCell"];
    }
    cell.selectBtn.selected = NO;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (self.defaultTitle.length>0) {
        if ([self.defaultTitle isEqualToString:_kindArray[indexPath.row]]){
            cell.selectBtn.selected = YES;
            cell.contentView.backgroundColor = [UIColor grayColor];
        }
    }
    [cell setMjSelectCell:_kindArray[indexPath.row]];
    return cell;
}
-(void)dismissing
{
    for (UIView* smallView in KEY_WINDOW.subviews)
    {
        if ([smallView isKindOfClass:[self class]])
        {
            [smallView removeFromSuperview];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.defaultTitle = _kindArray[indexPath.row];
    [_kindView reloadData];
    if (self.selectBlock) {
        self.selectBlock(_kindArray[indexPath.row]);
    }
    [self dismissing];
}
@end
