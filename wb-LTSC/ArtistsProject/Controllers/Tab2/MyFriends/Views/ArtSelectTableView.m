//
//  ArtSelectTableView.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtSelectTableView.h"

@interface ArtSelectTableView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* kindView;
@property(nonatomic,strong)NSMutableArray* kindArray;
@end

@implementation ArtSelectTableView
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.50];
        self.userInteractionEnabled = YES;
        _kindArray = [[NSMutableArray alloc]init];
    _kindView = [[UITableView alloc]init];
    _kindView.dataSource=self;
    _kindView.delegate=self;
    _kindView.scrollEnabled = NO;
    _kindView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.kindView];
        
    }
    return self;
}
-(void)showArtSelectWithArr:(NSArray*)arr{
    [KEY_WINDOW addSubview:self];
    [_kindArray removeAllObjects];
    [_kindArray addObjectsFromArray:arr];
    _kindView.frame = CGRectMake(30,SCREEN_HEIGHT/2-(arr.count*40)/2, SCREEN_WIDTH-60, arr.count*40);
    [_kindView reloadData];
}
-(void)hideArtSelectView{
   
        for (UIView* smallView in KEY_WINDOW.subviews)
        {
            if ([smallView isKindOfClass:[self class]])
            {
                [smallView removeFromSuperview];
            }
        }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _kindArray.count>0?_kindArray.count:0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    cell.textLabel.text = _kindArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock(_kindArray[indexPath.row]);
    }
    [self hideArtSelectView];
}

@end
