//
//  HomeController.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYShareMenuItem : NSObject

@property (nonatomic, copy) NSString *imageName;/**< 每一项的图片名 */
@property (nonatomic, copy) NSString *title;/**< 每一项的标题 */


+ (instancetype)shareMenuItemWithImageName:(NSString *)imageName itemTitle:(NSString *)itemTitle;
- (instancetype)initShareMenuItemWithImageName:(NSString *)imageName itemTitle:(NSString *)itemTitle;

@end
