//
//  CarPositioning.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "BMKPoiInfo+AddModels.h"
#import "CarListModel.h"

@interface CarPositioning : THBaseViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>


@property (weak, nonatomic) UILabel *label_Addr;

@property (strong, nonatomic) BMKMapView *bMapView;
///车辆定位数据
@property (strong,nonatomic)NSString * carID;
///显示的数据
@property (nonatomic, strong) BMKPoiInfo * poiInfo;

@end
