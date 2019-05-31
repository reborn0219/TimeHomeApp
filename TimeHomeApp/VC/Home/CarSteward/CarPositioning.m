//
//  CarPositioning.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "CarManagerPresenter.h"
#import "CarPositioning.h"
#import "CarAnimatedAnnotationView.h"
#import "AnimatedAnnotation.h"
#import "UIImage+ImageRotate.h"
#import "CarLocationInfo.h"
#import "CarLocationPresenter.h"

@interface CarPositioning ()
{
    
    BMKPointAnnotation* pointAnnotation;
    AnimatedAnnotation* animatedAnnotation;
    CarAnimatedAnnotationView *annotationView;
    
    BMKGeoCodeSearch* _geocodesearch;
    ///车辆定位处理
    CarLocationPresenter * clPresenter;
}

@end

@implementation CarPositioning

- (void)viewDidLoad {
    
    [super viewDidLoad];    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"车辆定位";
    self.bMapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.bMapView.zoomLevel = 16;

    self.bMapView.trafficEnabled=YES;
    self.bMapView.showMapScaleBar=YES;
    self.bMapView.frame = self.view.bounds;

    self.bMapView.mapScaleBarPosition = CGPointMake(10,10);
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    [self.view addSubview:_bMapView];

    self.bMapView.delegate = self;
    _geocodesearch.delegate = self;
    [_bMapView setHidden:YES];
    [self creatGPSButton ];
    
    
}


- (void)GPSClick:(UIButton *)button {
    if (![self isUseLocation]) {
        return;
    }

    [self repositionAction];
    
}
-(void)creatGPSButton
{
    UIButton *GPSButton = [[UIButton alloc] init];
    [GPSButton setImage:[UIImage imageNamed:@"车辆定位图标.png"] forState:UIControlStateNormal];
    [GPSButton addTarget:self action:@selector(GPSClick:) forControlEvents:UIControlEventTouchUpInside];
    GPSButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:GPSButton];
    GPSButton.sd_layout.rightSpaceToView(self.view,20).bottomSpaceToView(self.view,20).widthIs(40).heightIs(40);
    
    [self createBackBarButton];
}
#pragma mark -- 返回按钮
-(void)createBackBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    
    [button setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)repositionAction
{
    ///添加获取定位
    [CarManagerPresenter getMyGPSWithCarID:_carID andBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode)
            {
                
                NSDictionary * dataDic = data;
                NSString * direction = [dataDic objectForKey:@"direction"];
                NSString * mapx = [dataDic objectForKey:@"mapx"];
                NSString * mapy = [dataDic objectForKey:@"mapy"];
                
                CarLocationInfo * carLocctionInfo = [[CarLocationInfo alloc]init];
                carLocctionInfo.lat = mapx.doubleValue;
                carLocctionInfo.lng = mapy.doubleValue;
                carLocctionInfo.direction = direction.doubleValue;

                
//              carLocctionInfo.lng = 116;
//              carLocctionInfo.lat = 39;
//              carLocctionInfo.direction = 180;
                
                
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = carLocctionInfo.lat;
                coordinate.longitude = carLocctionInfo.lng;
                
                self.bMapView.centerCoordinate = coordinate;
              
                [self upDataImg:carLocctionInfo];
                
                
                
                BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
                reverseGeocodeSearchOption.location = coordinate;
                
                [_bMapView setHidden:NO];

                BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
                
                if(flag)
                {
                    NSLog(@"转地址发送成功");
                }
                else
                {
                    NSLog(@"转地址发送失败");
                }
                
            }
            
        });
    }];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (![self isUseLocation]) {
        return;
    }
    [self repositionAction];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
}
- (void)dealloc {
    
    if (self.bMapView) {
        self.bMapView = nil;
    }
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}
-(void)upDataImg:(CarLocationInfo *) carLocctionInfo
{
    
    NSMutableArray *images = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"车辆定位_地图标记"];
    image=[image imageRotatedByDegrees:carLocctionInfo.direction];
    [images addObject:image];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = carLocctionInfo.lat;
    coordinate.longitude = carLocctionInfo.lng;
    
    if (animatedAnnotation) {
        [self.bMapView removeAnnotation:animatedAnnotation];
    }
    animatedAnnotation = nil;
    animatedAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    animatedAnnotation.animatedImages = images;
    [self.bMapView addAnnotation:animatedAnnotation];
    
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
  
    if ([annotation isKindOfClass:[AnimatedAnnotation class]])
    {
        
        annotationView = (CarAnimatedAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnimatedAnnotationIdentifier"];
        
        if (annotationView == nil)
        {
            annotationView = [[CarAnimatedAnnotationView alloc] initWithAnnotation:annotation
                                                                   reuseIdentifier:@"AnimatedAnnotationIdentifier"];
        }
        
        annotationView.canShowCallout   = YES;
        return annotationView;
    }
    return nil;
    
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView setCenterCoordinate:view.annotation.coordinate animated:NO];
    
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        
        NSString* showmeg;

        showmeg = [NSString stringWithFormat:@"当前位置:%@",result.address];

    }
}

@end
