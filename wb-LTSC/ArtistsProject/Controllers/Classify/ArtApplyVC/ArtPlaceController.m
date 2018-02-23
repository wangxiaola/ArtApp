//
//  ArtPlaceController.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtPlaceController.h"
#import "ArtApplyCell.h"
#import "CityModelData.h"
#import "MySingleton.h"
@interface ArtPlaceController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger selectRowWithProvince;
    NSInteger selectRowWithCity;
    NSInteger selectRowWithTown;
    NSMutableArray *proviceArr;
    NSMutableArray *stateArr;
    NSInteger count;
    
}
@property (nonatomic ,strong) UITableView *tableView;
// city
@property (nonatomic, strong) CityModelData *cityModel;
// dataArray
//@property (nonatomic, strong) NSMutableArray *proviceArr;

@end

@implementation ArtPlaceController

- (void)dealloc
{
    
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ArtApplyCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (CityModelData *)cityModel{
    
    if (_cityModel==nil) {
        MySingleton *mySing = [MySingleton shareMySingleton];
        if (mySing.cityModel) {
            _cityModel = mySing.cityModel;
        }
        else{
            NSString *jsonPath=[[NSBundle mainBundle]pathForResource:@"province_data.json" ofType:nil];
            NSData *jsonData=[[NSData alloc]initWithContentsOfFile:jsonPath];
            NSString *stringValue=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary *dicValue = [mySing getObjectFromJsonString:stringValue];  // 将本地JSON数据转为对象
            _cityModel=[CityModelData mj_objectWithKeyValues:dicValue];
            mySing.cityModel=_cityModel;
        }
    }
    return _cityModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择城市";
    proviceArr = (NSMutableArray *)self.cityModel.province;
    stateArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (count%3== 0) {
        return proviceArr.count;
    }else if (count%3 == 1){
        Province *province = proviceArr[selectRowWithProvince];
        return province.city.count;
    }else{
        Province *province = proviceArr[selectRowWithProvince];
        City *city = province.city[selectRowWithCity];
        return city.district.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArtApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (count%3 == 0) {
        Province *pro = proviceArr[indexPath.row];
        cell.title.text = pro.name;
    }else if (count % 3 == 1){
        Province *province = proviceArr[selectRowWithProvince];
        City *city = province.city[indexPath.row];
        cell.title.text = city.name;
    }else{
        Province *province = proviceArr[selectRowWithProvince];
        City *city = province.city[selectRowWithCity];
        District *dictrict=city.district[indexPath.row];
        cell.title.text = dictrict.name;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (count%3 == 0) {
        selectRowWithProvince = indexPath.row;
        Province *pro = proviceArr[selectRowWithProvince];
        [stateArr addObject:pro.name];
    }else if (count%3 == 1){
        selectRowWithCity = indexPath.row;
        Province *province = proviceArr[selectRowWithProvince];
        [stateArr addObject:province.city[selectRowWithCity].name];
    }else{
        selectRowWithTown = indexPath.row;
        Province *province = proviceArr[selectRowWithProvince];
        City *city = province.city[selectRowWithCity];
        [stateArr addObject:city.district[selectRowWithTown].name];
        if(_saveBtnCilck){
            _saveBtnCilck([stateArr componentsJoinedByString:@","]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    count ++;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
