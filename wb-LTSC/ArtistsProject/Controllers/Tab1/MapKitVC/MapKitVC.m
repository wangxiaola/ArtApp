//
//  MapKitVC.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "MapKitVC.h"
#import <MapKit/MapKit.h>
#import "LHAnnotation.h"

@interface MapKitVC ()<MKMapViewDelegate>{
    MKMapView *mapView;
}

@end

@implementation MapKitVC
@synthesize navTitle,coordinate,titleDAtou,subtitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=navTitle;
    
    mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    mapView.delegate=self;
    mapView.mapType=MKMapTypeStandard;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.924115, 116.186063) animated:YES];
    /**
     *Set to YES to add the user location annotation to the map and start updating its location
     */
    mapView.showsUserLocation=NO;
    /**
     *Zoom and scroll are enabled by default.
     */
    mapView.scrollEnabled=YES;
    mapView.zoomEnabled=YES;
    /**
     *Rotate and pitch are enabled by default on Mac OS X and on iOS 7.0 and later.
     */
    mapView.pitchEnabled=YES;
    mapView.rotateEnabled=YES;
    
    CLLocationCoordinate2D center;
    center.latitude=coordinate.latitude;
    center.longitude=coordinate.longitude;

    
    MKCoordinateSpan span;
    span.latitudeDelta=0.01;//地图的精度，越小越准确
    span.longitudeDelta=0.01;//地图的精度，越小越准确
    MKCoordinateRegion region={center,span};
    [mapView setRegion:region];
    
    [self.view addSubview:mapView];
    
    //地图的范围 越小越精确
    LHAnnotation* annotation=[[LHAnnotation alloc]init];
    annotation.coordinate=coordinate;
    annotation.title=titleDAtou;
    annotation.subtitle=subtitle;
    [mapView addAnnotation:annotation];
}

@end
