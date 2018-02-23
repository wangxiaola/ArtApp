//
//  ArtCitySelectVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtCitySelectVc.h"

@interface ArtCitySelectVc ()
{
    BOOL _isSecondCity;
}
@property(nonatomic,copy)NSString* cityStr;
@property(nonatomic,strong)NSMutableArray* cityArr;
@end

@implementation ArtCitySelectVc
-(void)createView{
    [super createView];
    _cityArr = [[NSMutableArray alloc]init];
    self.tabView.backgroundColor =  BACK_CELL_COLOR;
    self.tabView.tableFooterView = [UIImageView new];
    [self.tabView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_jsonnew" ofType:@"txt"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray* firstKeyArr = [NSMutableArray arrayWithArray:[dic allKeys]];
    
        for (int i = 0; i < firstKeyArr.count; ++i) {
            for (int j = 0; j < firstKeyArr.count-1; ++j){
                NSInteger leftInter = [[NSString stringWithFormat:@"%@",firstKeyArr[j]] integerValue];
                NSInteger rightInter = [[NSString stringWithFormat:@"%@",firstKeyArr[j+1]] integerValue];
    
                //根据索引的`相邻两位`进行`比较`
                if (leftInter > rightInter) {
    
                    [firstKeyArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
                
            }
        }
    
    for (int i=0; i<firstKeyArr.count; i++) {
        NSString* str = firstKeyArr[i];
        if ([str isEqualToString:@"310000"]) {
            [firstKeyArr removeObjectAtIndex:i];
            [firstKeyArr insertObject:str atIndex:2];
        }else if ([str isEqualToString:@"500000"]){
            
            [firstKeyArr removeObjectAtIndex:i];
            [firstKeyArr insertObject:str atIndex:3];
           
        }
    }
    
    
    for (NSString* keyStr in firstKeyArr) {
        NSDictionary* smallDic = dic[keyStr];
        [_cityArr addObject:smallDic];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cityArr.count>0?_cityArr.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSDictionary* dic = _cityArr[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSecondCity){
        if (self.selectBlock){
            self.selectBlock(_cityArr[indexPath.row],_cityStr);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        _cityStr = _cityArr[indexPath.row][@"title"];
        _isSecondCity = YES;
        NSDictionary* dic = _cityArr[indexPath.row][@"areas"];
        NSMutableArray* firstKeyArr = [NSMutableArray arrayWithArray:[dic allKeys]];
        
        for (int i = 0; i < firstKeyArr.count; ++i) {
            for (int j = 0; j < firstKeyArr.count-1; ++j){
                NSInteger leftInter = [[NSString stringWithFormat:@"%@",firstKeyArr[j]] integerValue];
                NSInteger rightInter = [[NSString stringWithFormat:@"%@",firstKeyArr[j+1]] integerValue];
                
                //根据索引的`相邻两位`进行`比较`
                if (leftInter > rightInter) {
                    
                    [firstKeyArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
                
            }
        }
        [_cityArr removeAllObjects];
        for (NSString* keyStr in firstKeyArr) {
            NSDictionary* smallDic = dic[keyStr];
            [_cityArr addObject:smallDic];
        }
        [self.tabView reloadData];
    }
}
@end
