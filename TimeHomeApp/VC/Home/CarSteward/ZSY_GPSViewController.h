//
//  ZSY_GPSViewController.h
//  TimeHomeApp
//  Created by 赵思雨 on 16/8/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司.
//  All rights reserved.

#import "THBaseViewController.h"
#import "ZSY_MyGPSModel.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "BMKPoiInfo+AddModels.h"

@interface ZSY_GPSViewController : THBaseViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>

///车辆定位数据
@property(nonatomic,strong)ZSY_MyGPSModel * GPSModel;
///1.车辆 2.服务
//@property(assign,nonatomic) int jumpCode;
///显示的数据
//@property (nonatomic, strong) BMKPoiInfo * poiInfo;

@end
