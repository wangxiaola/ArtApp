//
//  YTXAddAddressViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXAddAddressViewController.h"
#import "YTXAddressViewModel.h"

@interface YTXAddAddressViewController ()<UITextFieldDelegate,JHPickerDelegate>

@property (nonatomic, strong) UITextField * CityText;

@property (nonatomic, strong) UITextField * addressText;

@property (nonatomic, strong) UITextField * nameText;

@property (nonatomic, strong) UITextField * phoneText;

@property (nonatomic, strong) UIButton * defaultBtn;

@property (nonatomic, strong) NSMutableArray * mArrayAddress;

@end

@implementation YTXAddAddressViewController

- (void)viewDidLoad {
    self.title = @"新增收货信息";
    if (_model) {
        self.title = @"编辑收货信息";
    }
    [super viewDidLoad];
    _mArrayAddress = @[].mutableCopy;
    [self createViews];
    self.view.backgroundColor = ColorHex(@"f6f6f6");
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
//    [(HNavigationBar*)self.navigationController.navigationBar setNavigationBarWithColor:[UIColor colorWithHexString:@"#C4B173"]];
}

#pragma mark - Private Methods

- (void)createViews {
    UIView * backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = kWhiteColor;
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];
    
    UILabel * cityLabel = [[UILabel alloc]init];
    cityLabel.text = @"城市:";
    cityLabel.textAlignment = NSTextAlignmentLeft;
    cityLabel.font = [UIFont systemFontOfSize:14.0f];
    [backgroundView addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView);
        make.left.equalTo(backgroundView).offset(8);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(44);
    }];
    
    UILabel * addressLabel = [[UILabel alloc]init];
    addressLabel.text = @"地址:";
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont systemFontOfSize:14.0f];
    [backgroundView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cityLabel.mas_bottom);
        make.left.equalTo(backgroundView).offset(8);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(44);
    }];
    
    _CityText = [[UITextField alloc]init];
    _CityText.placeholder = @"请输入城市";
    _CityText.font = kFont(14);
    _CityText.tag = 1;
    _CityText.delegate = self;
    _CityText.adjustsFontSizeToFitWidth = YES;
    _CityText.textAlignment = NSTextAlignmentLeft;
    [backgroundView addSubview:_CityText];
    [_CityText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityLabel.mas_right).offset(8);
        make.top.bottom.equalTo(cityLabel);
        make.right.equalTo(backgroundView).offset(-8);
    }];
        
    _addressText = [[UITextField alloc]init];
    _addressText.placeholder = @"请输入地址";
    _addressText.font = kFont(14);
    _addressText.adjustsFontSizeToFitWidth = YES;
    _addressText.textAlignment = NSTextAlignmentLeft;
    [backgroundView addSubview:_addressText];
    [_addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right).offset(8);
        make.top.bottom.equalTo(addressLabel);
        make.right.equalTo(backgroundView).offset(-8);
    }];
    
    UILabel * phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"电话:";
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [UIFont systemFontOfSize:14.0f];
    [backgroundView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom);
        make.width.mas_equalTo(34);
        make.left.equalTo(backgroundView).offset(8);
        make.height.mas_equalTo(44);
    }];
    
    _phoneText = [[UITextField alloc]init];
    _phoneText.placeholder = @"请输入电话";
    _phoneText.font = kFont(14);
    _phoneText.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:_phoneText];
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right).offset(8);
        make.top.bottom.equalTo(phoneLabel);
        make.right.equalTo(backgroundView).offset(-8);
    }];
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"姓名:";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    [backgroundView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom);
        make.width.mas_equalTo(34);
        make.left.equalTo(backgroundView).offset(8);
        make.height.mas_equalTo(44);
    }];
    
    _nameText = [[UITextField alloc]init];
    _nameText.placeholder = @"请输入姓名";
    _nameText.font = kFont(14);
    _nameText.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:_nameText];
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(8);
        make.top.bottom.equalTo(nameLabel);
        make.right.equalTo(backgroundView).offset(-8);
    }];
    
    UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"确认新增" forState:UIControlStateNormal];
    if (_model) {
        [commitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    }
    [commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.cornerRadius = 5;
    [commitBtn setBackgroundColor:[UIColor colorWithHexString:@"D49D66"]];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(44);
    }];
    
    UILabel * defaultLabel = [[UILabel alloc]init];
    defaultLabel.text = @"是否选择为默认地址:";
    defaultLabel.textAlignment = NSTextAlignmentLeft;
    defaultLabel.font = [UIFont systemFontOfSize:14.0f];
    [backgroundView addSubview:defaultLabel];
    [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(backgroundView).offset(8);
        make.height.mas_equalTo(44);
    }];
    
    _defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_defaultBtn setImage:[UIImage imageNamed:@"icon_Default_unSelected.png"] forState:UIControlStateNormal];
    [_defaultBtn setImage:[UIImage imageNamed:@"icon_Default_selected.png"] forState:UIControlStateSelected];
    [backgroundView addSubview:_defaultBtn];
    [_defaultBtn addTarget:self action:@selector(defaultBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(defaultLabel.mas_right).offset(8);
        make.top.bottom.equalTo(defaultLabel);
        make.width.height.mas_equalTo(15);
        make.bottom.equalTo(backgroundView).offset(-8);
    }];
    
    if (_model) {
        _nameText.text = _model.name;
        _phoneText.text = _model.phone;
        NSArray *arr = [_model.address componentsSeparatedByString:@" "];
        if(arr.count == 2){
            _CityText.text = arr[0];
            _addressText.text = arr[1];
        }else{
           _addressText.text = _model.address;
        }
        
        _defaultBtn.selected = _model.isDefault;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
//        [textField resignFirstResponder];
//        JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
//        picker.delegate = self;
//        picker.arrayType = AreaArray;
//        [self.view addSubview:picker];
        HAddressSelector* pop = [[HAddressSelector alloc] initWithFinishSelectedBlock:^(NSArray* IDs, NSArray* Names) {
            NSMutableArray* selectedItems = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < IDs.count; i++) {
                HKeyValuePair* item = [[HKeyValuePair alloc] initWithValue:IDs[i] andDisplayText:Names[i]];
                [selectedItems addObject:item];
            }
            textField.text =[NSString stringWithFormat:@"%@-%@",Names[0],Names[1]];
            if (Names.count>2) {
                textField.text = [NSString stringWithFormat:@"%@-%@",textField.text,Names[2]];
            }
            
        }
        andClickedCancelButtonBlock:nil
        andClickedClearButtonBlock:nil];
        [self presentSemiViewController:pop];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)PickerSelectorIndixString:(NSString *)str
{
    _CityText.text = str;
}

- (void)defaultBtnAction {
    _defaultBtn.selected = !_defaultBtn.selected;
}

- (void)commitBtnAction {
    if (_nameText.text.length == 0 ||
        _phoneText.text.length == 0 ||
        _addressText.text.length == 0 ||
        _CityText.text.length == 0
        ) {
        [self showErrorHUDWithTitle:@"信息填写不完整" SubTitle:@"请补充完整信息再提交" Complete:nil];
        return;
    }
    if (![self isLogin]) {
        return;
    }
    NSString * defaultStr = nil;
    if (_isSetDefault || _defaultBtn.selected) {
        defaultStr = @"1";
    } else {
        defaultStr = @"0";
    }
    
    NSString * act = @"addaddress";
    NSDictionary * dict = @{
                            @"uid" : [Global sharedInstance].userID,
                            @"address" : [NSString stringWithFormat:@"%@ %@",_CityText.text,_addressText.text],
                            @"name" : _nameText.text,
                            @"phone" : _phoneText.text,
                            @"default" : defaultStr
                            };
    if (_model) {
        act = @"editaddress";
        dict = @{
                 @"uid" : [Global sharedInstance].userID,
                 @"address" : [NSString stringWithFormat:@"%@ %@",_CityText.text,_addressText.text],
                 @"name" : _nameText.text,
                 @"phone" : _phoneText.text,
                 @"default" : defaultStr,
                 @"id":_model.aid
                 };
    }
    [self showLoadingHUDWithTitle:@"正在添加" SubTitle:nil];
   
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpPostRequestWithActionName:act andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [self showOkHUDWithTitle:@"添加成功" SubTitle:nil Complete:nil];
            for (NSDictionary * dict in responseObject) {
                YTXAddressModel * model = [YTXAddressModel modelWithDictionary:dict];
                if ([model.defaultStr isEqualToString:@"1"]) {
                    [Global sharedInstance].addressModel = model;
                    YTXAddressViewModel * viewModel = [YTXAddressViewModel modelWithAddressModel:model];
                    [_mArrayAddress insertObject:viewModel atIndex:0];
                } else {
                    YTXAddressViewModel * viewModel = [YTXAddressViewModel modelWithAddressModel:model];
                    [_mArrayAddress addObject:viewModel];
                }
            }
            if (_didAddSucessBlock) {
                _didAddSucessBlock(_mArrayAddress.copy);
            }
        }
        [self.hudLoading hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hide:YES];
    }];
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
