//
//  ArtSelectTableView.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtSelectTableView : UIView
@property(nonatomic,copy)void(^selectBlock)(NSString*);
-(void)showArtSelectWithArr:(NSArray*)arr;
@end
