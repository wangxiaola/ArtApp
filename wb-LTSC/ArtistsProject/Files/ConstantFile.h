//
//  ConstantFile.h
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/4.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#ifndef ConstantFile_h
#define ConstantFile_h

#define Screen_Width    [UIScreen mainScreen].bounds.size.width
#define Screen_Height   [UIScreen mainScreen].bounds.size.height

#define kDefaultColor   RGBCOLOR(169, 33, 41)

// 接口配置
// 开发版本配置
#ifdef DEBUG

//#define AppUrlRoot   @"http://test-api.lotuschen.com/api.php"
//#define AppUrlRoot   @"http://test-lotuschen.artart.cn/api.php"

#define AppUrlRoot  @"http://testapi.artart.cn/api.php" //2.4

// 发布版本配置
#else

//#define AppUrlRoot   @"http://api.lotuschen.com/api.php"
//#define AppUrlRoot   @"http://lotuschen.artart.cn/api.php"
#define AppUrlRoot     @"http://api.artart.cn/api.php"  //2.4

#endif

// 签名publicKey配置

//api.artart.cn
#define  kPublicKey     @"ZGZvI1mi8Q"
//lotuschen.artart.cn
//#define  kPublicKey   @"Nlv6IWtZXe"



#endif /* ConstantFile_h */


