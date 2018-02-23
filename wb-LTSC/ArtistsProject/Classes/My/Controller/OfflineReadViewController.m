//
//  OfflineReadViewController.m
//  meishubao
//
//  Created by LWR on 2017/2/28.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "OfflineReadViewController.h"
#import "YZTagList.h"
#import "GeneralConfigure.h"
#import "ProgressView.h"
#import "MSBArticleDetailModel.h"
#import "OfflineListViewController.h"

@interface OfflineReadViewController () {

    BOOL _isLoading;
}

@property (nonatomic, strong) YZTagList      *tagList;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) UIView         *chooseV;
@property (nonatomic, strong) ProgressView   *progressV;
@property (nonatomic, strong) NSMutableArray *term_idArr;

@end

@implementation OfflineReadViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.term_idArr removeAllObjects];
}

- (void)viewDidDisappear:(BOOL)animated {

    [self.progressV settingDownImageShow:YES loading:NO];
    [self overturnBtn];
    [super viewDidDisappear:animated];
}

// 翻转按钮
- (void)overturnBtn {
    
    for (UIButton *btn in self.tagList.tagButtons) {
        
        if (btn.selected) {
            
            btn.selected = NO;
            [btn setBackgroundColor:self.tagList.tagBackgroundColor];
        }
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 1. 初始化
    [self setup];
}

- (void)setup {

    self.title = @"离线阅读";
 
    [self.view addSubview:self.tagList];
    
    // 选择下载内容
    [self.view addSubview:self.chooseV];
    [self.view addSubview:self.progressV];
}

#pragma makr - 点击下载
- (void)downTap {

    if (_isLoading) {
        
        // 开始请求
        NSMutableString     *str = [[NSMutableString alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSInteger count = self.term_idArr.count;
        for (NSInteger i = 0; i < count; i++) {
            
            ArticleCategoryModel *model = self.term_idArr[i];
            [dic setObject:model.name forKey:model.term_id];
            [str appendString: model.term_id];
            if (i != count - 1) {
                
                [str appendString:@","];
            }
        }
        
        __weak __block typeof (self) weakSlef = self;
        __block NSInteger num = 0;
        [[LLRequestServer shareInstance] requestOfflineCategory:1 term_id:str pagesize:10 success:^(LLResponse *response, id data) {
            
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                
                NSArray *keyArr = [data allKeys];
                for (NSString *key in keyArr) {
                    
                    NSArray *arr = data[key];
                    num += arr.count;
                }
                if (num == 0) {
                    
                    [weakSlef hudTip:@"该标签暂无数据,请重新选择"];
                    [weakSlef overturnBtn];
                    [weakSlef.progressV settingDownImageShow:YES loading:NO];
                    return;
                }
                [weakSlef.progressV settingProgerssWithSub:0 all:num];
                [weakSlef.progressV settingDownImageShow:NO loading:YES];
                
                __block NSInteger downedNum = 0;
                for (NSString *key in keyArr) {
                    
                    NSArray *arr = data[key];
                    for (NSString *tid in arr) {
                        
                        [[LLRequestServer shareInstance] requestArticleDetailWithArticleId:tid success:^(LLResponse *response, id data) {
                            downedNum += 1;
                            if (data && [data isKindOfClass:[NSDictionary class]]) {
                                
                                MSBArticleDetailModel *detailModel = [MSBArticleDetailModel mj_objectWithKeyValues:data];
                                detailModel.name = dic[key];
                                detailModel.term_id = key;
                                detailModel.post_id = tid;
                                [detailModel saveToDB];
                                
                                _isLoading = NO;
                                [weakSlef.progressV settingProgerssWithSub:downedNum all:num];
                                if (downedNum == num) {
                                    
                                    [weakSlef toShowList];
                                }
                            }
                        } failure:^(LLResponse *response) {
                            
                            downedNum += 1;
                            _isLoading = NO;
                            [weakSlef.progressV settingProgerssWithSub:downedNum all:num];
                            
                            if (downedNum == num) {
                                
                                [weakSlef toShowList];
                            }
                            
                        } error:^(NSError *error) {
                            
                            downedNum += 1;
                            _isLoading = NO;
                            [weakSlef.progressV settingProgerssWithSub:downedNum all:num];
                            if (downedNum == num) {
                                
                                [weakSlef toShowList];
                            }
                        }];
                    }
                }
            }
        } failure:^(LLResponse *response) {
            
            [weakSlef hudTip:response.msg];
            [weakSlef.progressV settingDownImageShow:YES loading:NO];
            _isLoading = YES;
        } error:^(NSError *error) {
            
            [weakSlef hudTip:@"网络错误"];
            [weakSlef.progressV settingDownImageShow:YES loading:NO];
            _isLoading = YES;
        }];
    }
}

- (void)toShowList {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _isLoading = YES;
        
        NSString *filePath = [kDocumentsPath stringByAppendingString:@"/termArr.data"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            OfflineListViewController *listVC = [[OfflineListViewController alloc] init];
            listVC.settingVC = self.settingVC;
            listVC.termArr = self.term_idArr;
            [self.navigationController pushViewController:listVC animated:YES];
        }
        [NSKeyedArchiver archiveRootObject:self.term_idArr toFile:filePath];
    });
}

#pragma mark - 懒加载
- (YZTagList *)tagList {

    if (!_tagList) {
        
        _tagList = [[YZTagList alloc] initWithFrame:CGRectMake(0, APP_NAVIGATIONBAR_H + self.chooseV.height, SCREEN_WIDTH, 200)];
        _tagList.backgroundColor    = [UIColor clearColor];
        _tagList.tagFont            = [UIFont systemFontOfSize:12.0];
        _tagList.tagButtonMargin    = 10;
        _tagList.tagMargin          = 25;
        _tagList.tagCornerRadius    = 5;
        if (isNightMode) {
            
            _tagList.tagBackgroundColor = RGBCOLOR(108, 108, 108);
        }else {
            
            _tagList.tagBackgroundColor = RGBCOLOR(223, 223, 223);
        }
        _tagList.changeBtnH         = NO;
        _tagList.changeBtnBGColor   = YES;
        
        // 添加标签
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.titleArr.count; i++) {
            
            ArticleCategoryModel *model = self.titleArr[i];
            if ([model.name isEqualToString:@"视频"]) {
                
                [self.titleArr removeObject:model];
            }else {
                
                [titles addObject:model.name];
            }
        }
        [_tagList addTags:titles];
        
        __weak __block typeof(self) weakSelf = self;
        _tagList.clickTagBlock = ^(NSString *tag, NSInteger index) {
            
            UIButton *btn =  weakSelf.tagList.tagButtons[index];
            if (btn.selected) {
                
                ArticleCategoryModel *model = weakSelf.titleArr[index];
                [weakSelf.term_idArr removeObject:model];
            }else {
            
                ArticleCategoryModel *model = weakSelf.titleArr[index];
                [weakSelf.term_idArr addObject:model];
            }
            
            if (weakSelf.term_idArr.count > 0) {
                
                [weakSelf.progressV settingDownImageShow:YES loading:YES];
            }else {
                
                [weakSelf.progressV settingDownImageShow:YES loading:NO];
            }
        };
    }
    return _tagList;
}

- (NSMutableArray *)titleArr {

    if (!_titleArr) {
        
        NSString *filepath = [kDocumentsPath stringByAppendingString:@"/category.data"];
        NDLog(@"--路径--%@", filepath);
        _titleArr = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:filepath]];
        
        ArticleCategoryModel *master   = [[ArticleCategoryModel alloc] init];
        master.name = @"大师";
        master.term_id = @"94";
        
        ArticleCategoryModel *people   = [[ArticleCategoryModel alloc] init];
        people.name = @"大家";
        people.term_id = @"23";
        
        ArticleCategoryModel *famous   = [[ArticleCategoryModel alloc] init];
        famous.name = @"名家";
        famous.term_id = @"95";
        
        ArticleCategoryModel *fresh    = [[ArticleCategoryModel alloc] init];
        fresh.name = @"新锐";
        fresh.term_id = @"96";
        
        ArticleCategoryModel *country  = [[ArticleCategoryModel alloc] init];
        country.name = @"中国国家画院";
        country.term_id = @"100";
        
        ArticleCategoryModel *internal = [[ArticleCategoryModel alloc] init];
        internal.name = @"国外艺术机构";
        internal.term_id = @"102";
        
        ArticleCategoryModel *foreign  = [[ArticleCategoryModel alloc] init];
        foreign.name = @"国外艺术机构";
        foreign.term_id = @"103";
        
        [_titleArr addObjectsFromArray:@[master, people, famous, fresh, country, internal, foreign]];
    }
    return _titleArr;
}

- (UIView *)chooseV {

    if (!_chooseV) {
        
        _chooseV = [[UIView alloc] initWithFrame:CGRectMake(0, APP_NAVIGATIONBAR_H, SCREEN_WIDTH, 40)];
        _chooseV.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xE8E8E8, 0x202020);

        UILabel *chooseLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 12, 40)];
        chooseLab.dk_textColorPicker = DKColorPickerWithRGB(0x7E7E7E, 0x989898);
        chooseLab.font = [UIFont systemFontOfSize:12.0];
        chooseLab.text = @"选择要下载的内容";
        [_chooseV addSubview:chooseLab];
    }
    return _chooseV;
}

- (NSMutableArray *)term_idArr {

    if (!_term_idArr) {
        
        _term_idArr = [[NSMutableArray alloc] init];
    }
    return _term_idArr;
}

- (ProgressView *)progressV {

    if (!_progressV) {
        
        _progressV = [[ProgressView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 82, SCREEN_WIDTH - 40, 42)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downTap)];
        [_progressV addGestureRecognizer:tap];
        _isLoading = YES;
    }
    return _progressV;
}

- (void)dealloc {

    if (self.progressV) {
        
        self.progressV = nil;
    }
    
    if (self.titleArr) {
        
        self.titleArr = nil;
    }
    
    if (self.term_idArr) {
        
        self.term_idArr = nil;
    }
}

@end
