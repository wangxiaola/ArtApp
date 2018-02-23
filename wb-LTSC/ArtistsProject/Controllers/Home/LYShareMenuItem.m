//
//  HomeController.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "LYShareMenuItem.h"

@implementation LYShareMenuItem

+ (instancetype)shareMenuItemWithImageName:(NSString *)imageName itemTitle:(NSString *)itemTitle{
    
    return [[LYShareMenuItem alloc] initShareMenuItemWithImageName:imageName itemTitle:itemTitle];
}

- (instancetype)initShareMenuItemWithImageName:(NSString *)imageName itemTitle:(NSString *)itemTitle{
    self = [super init];
    if (self) {
        self.imageName = imageName;
        self.title = itemTitle;
        
    }
    return self;
}
@end
