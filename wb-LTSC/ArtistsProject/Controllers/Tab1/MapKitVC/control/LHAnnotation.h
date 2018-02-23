//
//  LHAnnotation.h
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LHAnnotation : NSObject<MKAnnotation>
// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
