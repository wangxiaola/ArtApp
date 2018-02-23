//
//  MSBCleanMemory.m
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCleanMemory.h"
#import "UIImageView+WebCache.h"
@implementation MSBCleanMemory
+ (void)clean{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    
    for ( NSString *p  in files) {
        NSError *error;
        NSString *path = [cachPath  stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ]  fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ]  removeItemAtPath :path  error :&error];
        }
    }
    [[SDWebImageManager sharedManager].imageCache clearDisk];
}
@end
