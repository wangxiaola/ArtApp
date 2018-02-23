//
//  MapKitVC.h
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HViewController.h"

@interface MapKitVC : HViewController

@property(strong,nonatomic)NSString *navTitle;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *titleDAtou;
@property (nonatomic, copy) NSString *subtitle;

@end
