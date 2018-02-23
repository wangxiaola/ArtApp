//
//  UserInfoVideoCell.m
//  ShesheDa
//
//  Created by chen on 16/8/2.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "UserInfoVideoCell.h"

@implementation UserInfoVideoCell {
    UIImageView* imgVideo;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView
{
    imgVideo = [[UIImageView alloc] init];
    imgVideo.backgroundColor = kClearColor;
    [self addSubview:imgVideo];
    [imgVideo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self).offset(KKWidth(30));
        make.centerY.equalTo(self);
        make.top.equalTo(self).offset(20);
        make.width.mas_equalTo(120 / 9 * 16);
    }];

    UIButton* btnRecord = [[UIButton alloc] init];
    [btnRecord setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [btnRecord setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnRecord.titleLabel.font = kFont(15); //[[Global sharedInstance]fontWithSize:15];
    [btnRecord addTarget:self action:@selector(btnRecord_Click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnRecord];
    [btnRecord mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(imgVideo).offset(70);
        make.left.equalTo(self).offset(KKWidth(570));
        make.height.width.width.mas_equalTo(20);
    }];
}
- (void)btnRecord_Click
{
    if (self.btndelBlock) {
        self.btndelBlock();
    }
}

- (void)setVideoUrl:(NSString*)videoUrl
{
    _videoUrl = videoUrl;

    //1.设置请求参数
    NSString* strVideoID = [self getVideoIDWithVideoUrl1:videoUrl];
    if (strVideoID.length < 1) {
        return;
    }
    NSDictionary* dict = @{ @"client_id" : youKuclientId,
        @"video_id" : strVideoID };
    //1.管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = 20.0f; //超时时间

    NSString* url = @"https://openapi.youku.com/v2/videos/show.json";
    //4 请求
    [manager GET:url
        parameters:dict
        success:^(NSURLSessionTask* operation, id responseObject) {
            NSString* strVideoUrl = [responseObject objectForKey:@"bigThumbnail"];
            [imgVideo sd_setImageWithURL:[NSURL URLWithString:strVideoUrl] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        }
        failure:^(NSURLSessionTask* operation, NSError* error){
        }];
}

- (NSString*)getVideoIDWithVideoUrl1:(NSString*)strVideo
{
    NSString* sub = @"";
    NSUInteger i = 0;
    NSUInteger iMoren = 4;
    NSRange start = [strVideo rangeOfString:@"vid="];
    i = start.location + iMoren;
    if (start.length == 0) {
        start = [strVideo rangeOfString:@"id_"];
        iMoren = 3;
        i = start.location + iMoren;
    }
    if (start.length == 0) {
        return @"";
    }
    NSLog(@"%lu", (unsigned long)strVideo.length);
    for (; i < strVideo.length; i++) {
        NSString* strCoin = [strVideo substringWithRange:NSMakeRange(i, 1)];
        int asciiCode = [strCoin characterAtIndex:0]; //65
        if (!((47 < asciiCode && asciiCode < 58) || (64 < asciiCode && asciiCode < 91) || (96 < asciiCode && asciiCode < 123) || asciiCode == 61)) {
            break;
        }
    }
    sub = [strVideo substringWithRange:NSMakeRange(start.location + iMoren, i - start.location - iMoren)];
    return sub;
}

@end
