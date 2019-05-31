//
//  ZSY_GPSViewController.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_GPSViewController.h"
#import "CarAnimatedAnnotationView.h"
#import "AnimatedAnnotation.h"
#import "UIImage+ImageRotate.h"
#import "CarLocationInfo.h"
#import "CarLocationPresenter.h"
@interface ZSY_GPSViewController ()
{
    BMKPointAnnotation* pointAnnotation;
    AnimatedAnnotation* animatedAnnotation;
    CarAnimatedAnnotationView *annotationView;
    
    BMKGeoCodeSearch* _geocodesearch;
    ///车辆定位处理
    CarLocationPresenter * clPresenter;
}
@property (nonatomic,strong) BMKMapView *mapView;//地图视图
@end

@implementation ZSY_GPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.zoomLevel = 16;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.924, 116.403);
    self.mapView.trafficEnabled=YES;
    self.mapView.showMapScaleBar=YES;
    
//    self.mapView.frame = CGRectMake(0, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.view.frame.size.height - self.mapView.frame.origin.y);
    //自定义比例尺的位置
    self.mapView.mapScaleBarPosition = CGPointMake(10,10);
    
    [self.view addSubview:self.mapView];
    
    UIButton *GPSButton = [[UIButton alloc] init];
    [GPSButton setImage:[UIImage imageNamed:@"车辆定位图标.png"] forState:UIControlStateNormal];
    [GPSButton addTarget:self action:@selector(GPSClick:) forControlEvents:UIControlEventTouchUpInside];
    GPSButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:GPSButton];
    GPSButton.sd_layout.rightSpaceToView(self.view,20).bottomSpaceToView(self.view,20).widthIs(40).heightIs(40);

    clPresenter=[CarLocationPresenter new];
    
//    if (self.jumpCode==1) {
//        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//        
//    }
//    else if (self.jumpCode==2)
//    {
//        
//    }
    self.navigationItem.title=self.title;

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.overlooking = -0.1;
    
    CGPoint pt;
    //    pt = CGPointMake(10,10);
    pt = CGPointMake(self.mapView.frame.size.width-40,10);
    [self.mapView setCompassPosition:pt];
    
    //    self.bMapView.showsUserLocation = NO;//先关闭显示的定位图层
    //    self.bMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    //    self.bMapView.showsUserLocation = YES;//显示定位图层
    [self addAnimatedAnnotation];
    
//    if (self.jumpCode==1) {
//        [self addAnimatedAnnotation];
//    }
//    else
//    {
//        [self addPointAnnotation];
//        
//        self.label_Addr.text=self.poiInfo.address;
//        self.mapView.centerCoordinate = self.poiInfo.pt;
//    }
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
//    if (self.jumpCode==1) {
        ///添加获取定位
    
#if 0
        [clPresenter GetAccessForAcc:self.GPSModel.username pw:self.carListModel.password upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(resultCode==SucceedCode)
                {
                    [clPresenter startCarTimeTorefresh:self.carListModel.imei upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(resultCode==SucceedCode)
                            {
                                CarLocationInfo * carLocctionInfo=(CarLocationInfo *)data;
                                CLLocationCoordinate2D coordinate;
                                coordinate.latitude = carLocctionInfo.lat;
                                coordinate.longitude = carLocctionInfo.lng;
                                self.bMapView.centerCoordinate = coordinate;
                                [self upDataImg:carLocctionInfo];
                                BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
                                reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
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
                            else if(resultCode==FailureCode)
                            {
                            }
                            else if(resultCode==NONetWorkCode)//无网络处理
                            {
                            }
                        });
                        
                    }];
                }
                else if(resultCode==FailureCode)
                {
                }
                else if(resultCode==NONetWorkCode)//无网络处理
                {
                }
            });
            
        }];
        self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    }
#endif
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
//    if (self.jumpCode==1) {
        self.mapView.delegate = nil; // 不用时，置nil
        _geocodesearch.delegate = nil; // 不用时，置nil
        ///添加刷新定位
        [clPresenter cancalTimer];
//    }
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)dealloc {
    if (self.mapView) {
        self.mapView = nil;
    }
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}



//添加标注
- (void)addPointAnnotation
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
//        pointAnnotation.coordinate = self.poiInfo.pt;
//        pointAnnotation.title = self.poiInfo.name;
//        pointAnnotation.subtitle = self.poiInfo.address;
    }
    [self.mapView addAnnotation:pointAnnotation];
}


-(void)upDataImg:(CarLocationInfo *) carLocctionInfo
{
    
//    self.label_Addr.text=[NSString stringWithFormat:@"当前速度:%@Km/h",carLocctionInfo.speed];
    
    NSMutableArray *images = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"地图标记"];
    image=[image imageRotatedByDegrees:carLocctionInfo.direction];
    [images addObject:image];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = carLocctionInfo.lat;
    coordinate.longitude = carLocctionInfo.lng;
    animatedAnnotation.coordinate=coordinate;
    animatedAnnotation.animatedImages = images;
    if (annotationView) {
        [annotationView setAnnotation:animatedAnnotation];
    }
}

// 添加动画Annotation
- (void)addAnimatedAnnotation {
    
    if(animatedAnnotation)
        return;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 39.925;
    coordinate.longitude = 116.404;
    animatedAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    //    animatedAnnotation.animatedImages   = images;
    //    animatedAnnotation.title            = @"初始";
    //    animatedAnnotation.subtitle         = @"初始";
    
    [self.mapView addAnnotation:animatedAnnotation];
    
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //    普通annotation
    if (annotation == pointAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView * annotationView1 = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView1 == nil) {
            annotationView1 = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView1.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView1.animatesDrop = YES;
            // 设置可拖拽
            annotationView1.draggable = NO;
        }
        return annotationView1;
    }
    if ([annotation isKindOfClass:[AnimatedAnnotation class]])
    {
        static NSString *animatedAnnotationIdentifier = @"AnimatedAnnotationIdentifier";
        
        annotationView = (CarAnimatedAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:nil];
        
        if (annotationView == nil)
        {
            annotationView = [[CarAnimatedAnnotationView alloc] initWithAnnotation:annotation
                                                                   reuseIdentifier:animatedAnnotationIdentifier];
        }
        
        //        annotationView.canShowCallout   = YES;
        annotationView.draggable        = YES;
        return annotationView;
    }
    
    return nil;
}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        NSString* showmeg;
        //        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"当前位置:%@",result.address];
//        self.label_Addr.text=showmeg;
        
        //        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        //        [myAlertView show];
    }
}




- (void)GPSClick:(UIButton *)button {
    
    NSLog(@"开始定位");
//    //开启定位
//    [self.service startUserLocationService];
//    
//    
//    
//    [self setUserImage];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
