//
//  MSBCommonQuestionVC.m
//  meishubao
//
//  Created by T on 16/12/19.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCommonQuestionVC.h"
#import "GeneralConfigure.h"

#import "MSBCommonQuestionBox.h"

@interface MSBCommonQuestionVC (){
    NSLayoutConstraint *_detailBottom;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;

@property(nonatomic,strong) MSBCommonQuestionBox *detailBox;

@end

@implementation MSBCommonQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"常见问题";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData{
    
    [self.detailBox setTitle:self.titleContent content:self.desContent];
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:_scrollView];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    }
    
    return _scrollView;
}

- (UIView *)scrollContentView {
    
    if (_scrollContentView == nil) {
        
        _scrollContentView = [[UIView alloc] init];
        [_scrollContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
//        [_scrollContentView setBackgroundColor:[UIColor clearColor]];
//        [_scrollContentView setClipsToBounds:YES];
        [self.scrollView addSubview:_scrollContentView];
        
        [self.scrollView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                          [NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                          [NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                          [NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                          [NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]
                                          ]];
    }
    
    return _scrollContentView;
}

- (MSBCommonQuestionBox *)detailBox {
    
    if (_detailBox == nil) {
        
        _detailBox = [[MSBCommonQuestionBox alloc] init];
        [_detailBox setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_detailBox setBackgroundColor:[UIColor clearColor]];
        [self.scrollContentView addSubview:_detailBox];
        [self.scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_detailBox]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_detailBox)]];
        [self.scrollContentView addConstraints:@[
                                                _detailBottom = [NSLayoutConstraint constraintWithItem:_detailBox attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-15.f],
                                                 [NSLayoutConstraint constraintWithItem:_detailBox attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeTop multiplier:1 constant:15.f]]];
    }
    
    return _detailBox;
}

- (void)setTitleContent:(NSString *)titleContent{
    _titleContent = titleContent;
}

- (void)setDesContent:(NSString *)desContent{
    _desContent = desContent;
}
@end
