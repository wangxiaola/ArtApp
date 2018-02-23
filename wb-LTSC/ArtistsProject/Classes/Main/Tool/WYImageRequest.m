//
//  WYImageRequest.m
//  adquan
//
//  Created by sks on 16/7/13.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "WYImageRequest.h"

@interface WYImageRequest () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, copy) void (^success) (id data);

@end
// (void (^)(id data))complection
@implementation WYImageRequest
+ (void)requestWithURL:(NSString *)url
               isCache:(BOOL)isCache
           complection:complection
                failer:failer {
    WYRequest *request = [[WYRequest alloc]init];
    [request requestWithURL:url isCache:isCache complection:complection failer:failer];
}
@end


@interface WYRequest ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

// 用来拼接数据
@property (nonatomic, strong) NSMutableData *data;

// 成功的回调
@property (nonatomic, copy) complection complection;

// 失败的回调
@property (nonatomic, copy) failer failer;

// 是否需要缓存
@property (nonatomic, assign) BOOL isCache;

// 图片的地址
@property (nonatomic, copy) NSString *fileURL;

@property (nonatomic, strong) NSURLConnection *conn;


@end

@implementation WYRequest

- (void)requestWithURL:(NSString *)url isCache:(BOOL)isCache  complection:complection failer:failer {
    
    self.complection = complection;
    self.failer  = failer;
    self.isCache = isCache;
    self.fileURL = url;
    
    if (isCache) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd",url.hash]];
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (self.complection) {
                self.complection(data);
                NSLog(@"缓存");
            }
            return;
        }
    }
    
    NSLog(@"下载");
    
    NSURL *urls = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urls];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    self.conn = conn;
    
    [conn start];
    
    // 添加取消下载的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelNetWork) name:MSBCanCelWYImageRequest object:nil];
}

- (void)cancelNetWork {
    [self.conn cancel];
}

#pragma mark - NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.isCache) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd",self.fileURL.hash]];
        [self.data writeToFile:path atomically:NO];
    }
    
    if (self.complection) {
        self.complection(self.data);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.failer) {
        self.failer(error);
    }
}

- (NSMutableData *)data {
    if (!_data) {
        _data = [[NSMutableData alloc] init];
    }
    
    return _data;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
