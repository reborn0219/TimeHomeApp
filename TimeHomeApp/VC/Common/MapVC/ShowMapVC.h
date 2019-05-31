//
//  CarMapVC.h
//  YouLifeApp
//
//  Created by us on 15/10/23.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "BMKPoiInfo+AddModels.h"
#import "CarListModel.h"

@interface ShowMapVC : THBaseViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_Addr;

@property (weak, nonatomic) IBOutlet BMKMapView *bMapView;
///车辆定位数据
@property(nonatomic,strong)CarListModel * carListModel;
///1.车辆 2.服务
@property(assign,nonatomic) int jumpCode;
///显示的数据
@property (nonatomic, strong) BMKPoiInfo * poiInfo;

@end
