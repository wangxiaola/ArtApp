//
//  sendBtn.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/7.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sendBtn : UIButton
@property(nonatomic,assign)CGRect imgFrame;
@property(nonatomic,assign)CGRect titleFrame;

@property(nonatomic, strong)HImagePicker *imageview;
@end
