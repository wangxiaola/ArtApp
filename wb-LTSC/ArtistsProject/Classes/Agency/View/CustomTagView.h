//
//  CustomTagView.h
//  meishubao
//
//  Created by LWR on 2017/2/16.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTagViewDelegate <NSObject>

@optional
- (void)tagListViewClick:(NSString *)title andType:(NSInteger) type andTag:(NSString *)tag;

@end

typedef enum {
    
    CustomTagViewTypeKind, // 种类
    CustomTagViewTypeArea  // 地区
} CustomTagViewType;

@interface CustomTagView : UIView

@property (nonatomic, assign) CustomTagViewType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray *tagArr;

@property (nonatomic, weak) id<CustomTagViewDelegate> delegate;

- (void)clearTags;

@end
