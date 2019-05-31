//
//  SetAddressMapVC.h
//  YouLifeApp
//
//  Created by 王好雷 on 15/11/15.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "BMKPoiInfo+AddModels.h"

@protocol MapAdrrBackDelegate <NSObject>

-(void)goBackAddr:(NSString *)addr location:(CLLocationCoordinate2D) loc;

@end


@interface GetAddressMapVC : THBaseViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *MapView;
@property (weak, nonatomic) IBOutlet UILabel *lab_Addr;
@property(weak,nonatomic) id <MapAdrrBackDelegate> delegate;


@end
