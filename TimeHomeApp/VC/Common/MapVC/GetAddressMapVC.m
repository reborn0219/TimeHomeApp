//
//  SetAddressMapVC.m
//  
//
//  Created by  on 15/11/15.
//  Copyright © 2015年 us. All rights reserved.
//

#import "GetAddressMapVC.h"
#import "BDMapFWPresenter.h"
#import "LocationInfo.h"

@interface GetAddressMapVC ()
{
    BMKPointAnnotation* pointAnnotation;
    BMKGeoCodeSearch* _geocodesearch;
    NSString * addr;//所在地址
    CLLocationCoordinate2D location;//所在地经纬度
    ///定们服务
    BDMapFWPresenter * bdMapPresenter;
}

@end

@implementation GetAddressMapVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    [self setupRightNavBarButton];    //设置右上角完成按钮

}
/**
 *  设置右上角完成按钮
 */
- (void)setupRightNavBarButton {
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeLocations)];
    rightBarButtonItem.tintColor = PURPLE_COLOR;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)completeLocations {
    if (self.delegate) {
        [self.delegate goBackAddr:self.lab_Addr.text location:location];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.lab_Addr.text] forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    LocationInfo *locationInfo = [[LocationInfo alloc] init];
//    locationInfo.longitude  = location.longitude;
//    locationInfo.latitude = location.latitude;
//    locationInfo.addres = self.lab_Addr.text;
//    [UserDefaultsStorage saveData:locationInfo forKey:@"LocationInfo"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.MapView.overlooking = -0.1;
    
    CGPoint pt;
    //    pt = CGPointMake(10,10);
    pt = CGPointMake(self.MapView.frame.size.width-40,10);
    [self.MapView setCompassPosition:pt];
    self.MapView.centerCoordinate = location;
    [self addPointAnnotation];
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.MapView viewWillAppear];
    self.MapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.MapView viewWillDisappear];
    self.MapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
    
//    if (self.delegate) {
//        [self.delegate goBackAddr:addr location:location];
//    }
}

- (void)dealloc {
    if (self.MapView) {
        self.MapView = nil;
    }
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}
-(void)initView {
    
    ///添加定位
//    location=[UserDefaultsStorage getLocation];
    location.latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue];
    location.longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue];
    self.lab_Addr.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];

//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"longitude"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"latitude"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",_TF_Addrs.text] forKey:@"address"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    LocationInfo * ltf = [UserDefaultsStorage getDataforKey:@"LocationInfo"];
//    if(ltf) {
//        
//        location.latitude=ltf.latitude;
//        location.longitude=ltf.longitude;
//        self.lab_Addr.text=ltf.addres;
//        
//    }
    bdMapPresenter=[BDMapFWPresenter new];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    self.MapView.zoomLevel = 16;
    self.MapView.centerCoordinate = location;
    self.MapView.trafficEnabled=YES;
    self.MapView.showMapScaleBar=YES;
    
    self.MapView.frame = CGRectMake(0, self.MapView.frame.origin.y, self.MapView.frame.size.width, self.view.frame.size.height - self.MapView.frame.origin.y);
    //自定义比例尺的位置
    self.MapView.mapScaleBarPosition = CGPointMake(10,10);
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
 

}
-(void)getAddr {
    
    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeocodeSearchOption.location = location;
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

//添加标注
- (void)addPointAnnotation {
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = location;
        pointAnnotation.title = addr;
    }
    [self.MapView addAnnotation:pointAnnotation];
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    //    普通annotation
    if (annotation == pointAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView * annotationView1 = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView1 == nil) {
            annotationView1 = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView1.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView1.animatesDrop = NO;
            // 设置可拖拽
            annotationView1.draggable = NO;
        }
        return annotationView1;
    }
    return nil;
}
-(void)mapStatusDidChanged:(BMKMapView *)mapView {
    
    location=mapView.centerCoordinate;
    pointAnnotation.coordinate=location;
    [self.MapView  removeAnnotation:pointAnnotation];
    [self.MapView addAnnotation:pointAnnotation];
    [self getAddr];
    
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == 0) {
        addr = [NSString stringWithFormat:@"%@",result.address];
       self.lab_Addr.text = addr;
       
    }
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    NSLog(@"paopaoclick");
}



@end
