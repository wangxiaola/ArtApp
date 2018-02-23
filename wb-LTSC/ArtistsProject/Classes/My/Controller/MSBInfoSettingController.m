//
//  MSBInfoSettingController.m
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBInfoSettingController.h"
#import "GeneralConfigure.h"

#import "LGMessSettingValueCell.h"
#import "LGMessSettingSwitchCell.h"
#import "MSBSettingValueArrowCell.h"
#import "MSBSettingPhotoArrowCell.h"

#import "MSBDataPickerAlert.h"
#import "MSBPickerAlertView.h"

#import "UITableView+Common.h"
#import "NSString+Device.h"
#import "UIImage+FixOrientation.h"

#import "MSBInfoItem.h"

#import "QiniuSDK.h"

@pickerify(LGMessSettingValueCell, cellTintColor)
@pickerify(LGMessSettingSwitchCell, cellTintColor)
@pickerify(MSBSettingValueArrowCell, cellTintColor)
@pickerify(MSBSettingPhotoArrowCell, cellTintColor)

@interface MSBInfoSettingController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

}
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray<NSMutableArray *> *datas;
@end

@implementation MSBInfoSettingController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xDCDCDC, 0x1c1c1c);
    
    [self requestServerData];
}

- (void)dealloc {
    
    if (_tableView) {
        
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _datas ? _datas.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_datas.count <= section || _datas.count <= section) {
        
        return 0;
    }
    
    return _datas[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.f;
//    return section == 0 ? 0.001f : 16.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    MSBInfoItem *item = _datas[section][row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.KEY_IDENTIFIER];

    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //[tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    MSBInfoItem *item = _datas[section][row];
    
    if ([item.KEY_IDENTIFIER isEqualToString:[LGMessSettingValueCell identifier]]) {
        LGMessSettingValueCell *valuecell = (LGMessSettingValueCell *)cell;
        //valuecell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        [valuecell setTitle:item.KEY_TITLE];
        [valuecell setValue:item.KEY_VALUE];
    }
    
    if ([item.KEY_IDENTIFIER isEqualToString:[MSBSettingValueArrowCell identifier]]) {
        MSBSettingValueArrowCell *valuecell = (MSBSettingValueArrowCell *)cell;
        //valuecell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        [valuecell setTitle:item.KEY_TITLE];
        [valuecell setValue:item.KEY_VALUE];
    }
    
    if ([item.KEY_IDENTIFIER isEqualToString:[MSBSettingPhotoArrowCell identifier]]) {
        MSBSettingPhotoArrowCell *valuecell = (MSBSettingPhotoArrowCell *)cell;
        //valuecell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        [valuecell setTitle:item.KEY_TITLE];
        [valuecell setValue:item.KEY_VALUE];
    }
    
    if ([item.KEY_IDENTIFIER isEqualToString:[LGMessSettingSwitchCell identifier]]) {
        LGMessSettingSwitchCell *valuecell = (LGMessSettingSwitchCell *)cell;
        //valuecell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        [valuecell setTitle:item.KEY_TITLE];
        [valuecell setOn:[item.KEY_VALUE intValue]];
        __weak __block typeof(self) weakSelf = self;
        valuecell.changeBlock = ^(BOOL isOn){
            //[weakSelf hudLoding];
            [[LLRequestBaseServer shareInstance] requestUserModifyInfoField:@"anonymity" fieldValue:[NSString stringWithFormat:@"%d", isOn] success:^(LLResponse *response, id data) {
                
                MSBUser *user = [MSBAccount getUser];
                user.anonymity = [NSString stringWithFormat:@"%d", isOn];
                [MSBAccount saveAccount:user];
                [weakSelf refreshDataSource:user];
            } failure:^(LLResponse *response) {
               // [weakSelf hiddenHudLoding];
            } error:^(NSError *error) {
               // [weakSelf hiddenHudLoding];
            }];
        };
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if ((section < 0 || section >= _datas.count) ||
        (row < 0 || row >= _datas[section].count)) {
        
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    MSBInfoItem *item = _datas[section][row];
    
    if (item.KEY_TAP && cell) {
        
        SEL sel = NSSelectorFromString(item.KEY_TAP);
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL, UITableViewCell *) = (void *)imp;
        func(self, sel, cell);
    }
}

- (void)requestServerData{
    [self hudLoding];
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestBaseServer shareInstance] requestUserInfoSuccess:^(LLResponse *response, id data) {
        if ([data isKindOfClass:[NSDictionary class]] && data) {
            MSBUser *user = [MSBAccount getUser];
            user.avatar = data[@"avatar"];
            user.nickname = data[@"nickname"];
            user.identity = data[@"identity"];
            user.sex = [data[@"sex"] integerValue];
            user.birthday = data[@"birthday"];
            user.anonymity = data[@"anonymity"];
            user.device = data[@"device"];
            [MSBAccount saveAccount:user];
            [weakSelf refreshDataSource:user];
            [weakSelf hiddenHudLoding];
            weakSelf.tableView.tableFooterView.hidden = NO;
        }
    } failure:^(LLResponse *response) {
        [weakSelf hiddenHudLoding];
        MSBUser *user = [MSBAccount getUser];
        [weakSelf refreshDataSource:user];
        weakSelf.tableView.tableFooterView.hidden = NO;
    } error:^(NSError *error) {
        [weakSelf hiddenHudLoding];
        MSBUser *user = [MSBAccount getUser];
        [weakSelf refreshDataSource:user];
        weakSelf.tableView.tableFooterView.hidden = NO;
    }];

}

- (void)refreshDataSource:(MSBUser *)user{
    [self.datas removeAllObjects];
    
    MSBInfoItem *account = [MSBInfoItem new];
    account.KEY_TITLE = @"通行证";
    account.KEY_VALUE = user.identity;
    account.KEY_IDENTIFIER = [LGMessSettingValueCell identifier];
    
    MSBInfoItem *photo = [MSBInfoItem new];
    photo.KEY_TITLE = @"头像";
    if (user.avarImage) {
        photo.KEY_VALUE = user.avarImage;
    }else{
        photo.KEY_VALUE = [UIImage imageNamed:@"people_collection_cell"];
    }
    photo.KEY_TAP = NSStringFromSelector(@selector(photoClick:));
    photo.KEY_IDENTIFIER = [MSBSettingPhotoArrowCell identifier];

    MSBInfoItem *nickname = [MSBInfoItem new];
    nickname.KEY_TITLE = @"昵称";
    nickname.KEY_VALUE =user.nickname;
    nickname.KEY_TAP = NSStringFromSelector(@selector(nicknameClick:));
    nickname.KEY_IDENTIFIER = [MSBSettingValueArrowCell identifier];

    MSBInfoItem *shengri = [MSBInfoItem new];
    shengri.KEY_TITLE = @"生日";
    if ([NSString isNull:user.birthday]) {
        shengri.KEY_VALUE = @"点击添加生日";
    }else{
        shengri.KEY_VALUE = user.birthday;
    }
    shengri.KEY_TAP = NSStringFromSelector(@selector(shengriClick:));
    shengri.KEY_IDENTIFIER = [MSBSettingValueArrowCell identifier];

    MSBInfoItem *sex = [MSBInfoItem new];
    sex.KEY_TITLE = @"性别";
    if (user.sex == 2) {
        sex.KEY_VALUE = @"女";
    }else{
        sex.KEY_VALUE = @"男";
    }
    
    sex.KEY_TAP = NSStringFromSelector(@selector(sexClick:));
    sex.KEY_IDENTIFIER = [MSBSettingValueArrowCell identifier];

    MSBInfoItem *sign = [MSBInfoItem new];
    sign.KEY_TITLE = @"签名";
    sign.KEY_VALUE =user.signature;
    sign.KEY_TAP = NSStringFromSelector(@selector(signClick:));
    sign.KEY_IDENTIFIER = [MSBSettingValueArrowCell identifier];
    
    MSBInfoItem *device = [MSBInfoItem new];
    device.KEY_TITLE = @"跟帖设备名称";
    if (![NSString isNull:user.device]) {
        device.KEY_VALUE = user.device;
    }else{
        device.KEY_VALUE = [NSString getCurrentDeviceName];
    }
    device.KEY_TAP = NSStringFromSelector(@selector(deviceChoice:));
    device.KEY_IDENTIFIER = [MSBSettingValueArrowCell identifier];

    MSBInfoItem *anonymity = [MSBInfoItem new];
    anonymity.KEY_TITLE = @"匿名跟帖";
    anonymity.KEY_VALUE = user.anonymity;
    anonymity.KEY_IDENTIFIER = [LGMessSettingSwitchCell identifier];

    [self.datas addObjectsFromArray:@[
                                     @[account],
                                     @[photo,nickname,shengri,sex,sign],
                                     @[device,anonymity]
                                     ]];
    
    [self.tableView reloadData];
}

/**头像修改*/
- (void)photoClick:(MSBSettingPhotoArrowCell *)cell{
    NDLog(@"photoClick");
    // 导航样式
    NSMutableDictionary *titleAttDic = [NSMutableDictionary dictionary];
    titleAttDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    titleAttDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = RGBCOLOR(181, 27, 32);
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拍照
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
        pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerVc.delegate = self;
        pickerVc.navigationBar.titleTextAttributes = titleAttDic;
        pickerVc.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xB51B20, 0x6f141a);
        [self presentViewController:pickerVc animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相册
        UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
        pickerVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerVc.delegate = self;
        pickerVc.navigationBar.titleTextAttributes = titleAttDic;
        pickerVc.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xB51B20, 0x6f141a);
        [self presentViewController:pickerVc animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSString *filename = [[@"msb/" stringByAppendingString:@"avatar/"] stringByAppendingFormat:@"%ld.jpg", time(NULL)];
    __weak __block typeof(self) weakSelf = self;
    [self hudLoding];
    [[LLRequestBaseServer shareInstance] requestPhotoTokenWithFilename:filename success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            CGFloat compression = 0.9f;
            UIImage *coppedImage = [image croppedImage];
            NSData *imagedata = UIImageJPEGRepresentation(coppedImage, compression);
            CGFloat size = [imagedata length] * .001f;
            // 500k
            CGFloat max = 500.f;
            CGFloat minCompression = 0.5f;
            while (size > max && compression > minCompression) {
                // 逐步压缩
                compression -= 0.1;
                imagedata = UIImageJPEGRepresentation(coppedImage, .5f);
                size = [imagedata length] * .001f;
            }
            [upManager putData:imagedata key:filename token:data[@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"---------%@",resp);
                if (info.statusCode == 200) {
                    MSBUser *user = [MSBAccount getUser];
                    user.avarImage = image;
                    [MSBAccount saveAccount:user];
                    [weakSelf refreshDataSource:user];
                    [weakSelf showSuccess:@"头像修改成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUT_SUCCESS" object:nil];
                } else {

                    [weakSelf showError:@"头像修改失败"];
                }
            } option:nil];
        }else{

            [weakSelf showError:@"头像修改失败"];
        }
    } failure:^(LLResponse *response) {

        [weakSelf showError:@"头像修改失败"];
    } error:^(NSError *error) {

        [weakSelf showError:@"头像修改失败"];
    }];
}

- (void)nicknameClick:(MSBSettingValueArrowCell *)cell{
    MSBUser *user = [MSBAccount getUser];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = user.nickname&&user.nickname.length>0?user.nickname:nil;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //修改昵称
        UITextField * nameField = alert.textFields.firstObject;
        [self reSetNickNameWithTextFiled:nameField];
    }]];

    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

-(void)reSetNickNameWithTextFiled:(UITextField *)textFiled
{
    MSBUser *user = [MSBAccount getUser];
    
    if (textFiled.text.length == 0) {
        textFiled.text = @"";
    }
    
//    if ([textFiled.text isEqualToString:user.nickname]) {
//        [self hudTip:@"昵称没有修改"];
//        return;
//    }
    
//    NSString * regex = @"^[a-zA-Z0-9\u4e00-\u9fa5_]{1,9}$";
//    NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    if (![pre evaluateWithObject:textFiled.text]) {
//        [self hudTip:@"昵称由1~9位字母汉字数字下划线组成"];
//        return;
//    }
    
    __weak __block typeof(self) weakSelf = self;
    [self hudLoding];
    [[LLRequestBaseServer shareInstance] requestUserModifyInfoField:@"nickname" fieldValue:textFiled.text success:^(LLResponse *response, id data) {

        user.nickname = textFiled.text;
        [MSBAccount saveAccount:user];
        [weakSelf refreshDataSource:user];
        [weakSelf showSuccess:@"昵称修改成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUT_SUCCESS" object:nil];
    } failure:^(LLResponse *response) {

        [weakSelf showError:@"昵称修改失败"];
    } error:^(NSError *error) {

        [weakSelf showError:@"昵称修改失败"];
    }];
}

-(void)reSetSignWithTextField:(UITextField *)textField
{
    MSBUser *user = [MSBAccount getUser];
    
    if (textField.text.length == 0) {
        textField.text = @"";
    }
    
//    if ([textField.text isEqualToString:user.signature]) {
//        [self hudTip:@"签名没有修改"];
//        return;
//    }
    
//    NSString * regex = @"^.{0,25}$";
//    NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    if (![pre evaluateWithObject:textField.text]) {
//        [self hudTip:@"个性签名长度为0~25"];
//        return;
//    }
    
    __weak __block typeof(self) weakSelf = self;
    [self hudLoding];
    [[LLRequestBaseServer shareInstance] requestUserModifyInfoField:@"signature" fieldValue:textField.text success:^(LLResponse *response, id data) {

        user.signature = textField.text;
        [MSBAccount saveAccount:user];
        [weakSelf refreshDataSource:user];
        [weakSelf showSuccess:@"签名修改成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUT_SUCCESS" object:nil];
    } failure:^(LLResponse *response) {

        [weakSelf showError:response.msg];
    } error:^(NSError *error) {

        [weakSelf showError:@"签名修改失败"];
    }];
}

- (void)shengriClick:(MSBSettingValueArrowCell *)cell{
    NDLog(@"shengriClick");
   MSBDataPickerAlert *dataPickAlert = [[MSBDataPickerAlert alloc] init];
     __weak __block typeof(self) weakSelf = self;
    [dataPickAlert showWithTitle:@"修改生日" content:nil ok:^(NSDate *date) {
         NDLog(@"ok%@", date);
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *birthday = [formatter stringFromDate:date];
        [weakSelf hudLoding];
        [[LLRequestBaseServer shareInstance] requestUserModifyInfoField:@"birthday" fieldValue:birthday success:^(LLResponse *response, id data) {

            MSBUser *user = [MSBAccount getUser];
            user.birthday = birthday;
            [MSBAccount saveAccount:user];
            [weakSelf refreshDataSource:user];
            [weakSelf showSuccess:@"生日修改成功"];
        } failure:^(LLResponse *response) {

            [weakSelf showError:@"生日修改失败"];
        } error:^(NSError *error) {

            [weakSelf showError:@"生日修改失败"];
        }];
        
        
    } cancel:nil];
}

- (void)sexClick:(MSBSettingValueArrowCell *)cell{
    __weak __block typeof(self) weakSelf = self;
    MSBUser *user = [MSBAccount getUser];
    
    MSBPickerAlertView *pickerView = [MSBPickerAlertView new];
    [pickerView showWithTitle:@"性别修改" content:@[@"男", @"女"]  index:(user.sex - 1) ok:^(NSInteger index) {
        NDLog(@"%tu=====", index);
        [weakSelf hudLoding];
        [[LLRequestBaseServer shareInstance] requestUserModifyInfoField:@"sex" fieldValue:[NSString stringWithFormat:@"%tu", (index + 1)] success:^(LLResponse *response, id data) {
            MSBUser *user = [MSBAccount getUser];
            user.sex = (index + 1);
            [MSBAccount saveAccount:user];
            [weakSelf refreshDataSource:user];
            [weakSelf showSuccess:@"性别修改成功"];
        } failure:^(LLResponse *response) {

            [weakSelf showError:@"性别修改失败"];
        } error:^(NSError *error) {

            [weakSelf showError:@"性别修改失败"];
        }];

    } cancel:nil];
}

- (void)signClick:(MSBSettingValueArrowCell *)cell
{
    MSBUser *user = [MSBAccount getUser];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"设置个性签名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = user.signature&&user.signature.length>0?user.signature:nil;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //修改签名
        UITextField * nameField = alert.textFields.firstObject;
        [self reSetSignWithTextField:nameField];
    }]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)deviceChoice:(MSBSettingValueArrowCell *)cell{
    __weak __block typeof(self) weakSelf = self;
    MSBPickerAlertView *pickerView = [MSBPickerAlertView new];
    [pickerView showWithTitle:@"选择设备名称" content:@[[NSString getCurrentDeviceName], @"iPhone",@"不显示"] index:0 ok:^(NSInteger index) {
        NDLog(@"%tu=====", index);
        NSString *device = nil;
        if (index == 0) {
            device = [NSString getCurrentDeviceName];
        }else if (index == 1){
            device = @"iPhone";
        }else{
            device = @"不显示";
        }
        [weakSelf hudLoding];
        [[LLRequestBaseServer shareInstance] requestUserModifyInfoField:@"device" fieldValue:device success:^(LLResponse *response, id data) {

            MSBUser *user = [MSBAccount getUser];
            user.device = device;
            [MSBAccount saveAccount:user];
            [weakSelf refreshDataSource:user];
            [weakSelf showSuccess:@"设备修改成功"];
        } failure:^(LLResponse *response) {

            [weakSelf showError:@"设备修改失败"];
        } error:^(NSError *error) {

            [weakSelf showError:@"设备修改失败"];
        }];

    } cancel:nil];
}

- (void)anonymity:(LGMessSettingSwitchCell *)cell{
    NDLog(@"anonymity");
}

#pragma mark - setter/getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, APP_NAVIGATIONBAR_H, SCREEN_WIDTH, SCREEN_HEIGHT - APP_NAVIGATIONBAR_H) style:UITableViewStyleGrouped];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        //[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dk_separatorColorPicker = CellLineColor;
        [self.view addSubview:_tableView];
         [_tableView registerClass:[LGMessSettingValueCell class] forCellReuseIdentifier:[LGMessSettingValueCell identifier]];
        [_tableView registerClass:[MSBSettingPhotoArrowCell class] forCellReuseIdentifier:[MSBSettingPhotoArrowCell identifier]];
        [_tableView registerClass:[MSBSettingValueArrowCell class] forCellReuseIdentifier:[MSBSettingValueArrowCell identifier]];
        [_tableView registerClass:[LGMessSettingSwitchCell class] forCellReuseIdentifier:[LGMessSettingSwitchCell identifier]];
    
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
 
    }
    
    return _tableView;
}

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
