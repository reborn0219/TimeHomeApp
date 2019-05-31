//
//  BDFWListPresenter.h
//  YouLifeApp
//
//  Created by us on 15/10/28.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BasePresenters.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "LocationInfo.h"
@interface BDMapFWPresenter : BasePresenters<BMKLocationManagerDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>

///定位获取到的信息
@property (nonatomic, strong) LocationInfo * location;
///定位返回结果处理
@property(nonatomic,copy) UpDateViewsBlock loactionBlock;

///定位信息返回结果处理
@property(nonatomic,copy) UpDateViewsBlock loactionInfoBlock;

///开始定位
-(void)startLocation;
///停止定位
-(void)stopLocation;

///搜索
-(void)seachBDData:(NSString *)KeyString centerpoint:(CLLocationCoordinate2D)location;

///地图上两点距离
+(NSString * ) calculateLineDistanceStart:(CLLocationCoordinate2D) startPoint endPoint:(CLLocationCoordinate2D) endpoint;

///获取位置信息，经纬度，城市，街道，区，地址
-(void)getLocationInfoForupDateViewsBlock:(UpDateViewsBlock) loactionInfoBlock;
///只获取位置
-(void)getLocationForupDateViewsBlock:(UpDateViewsBlock) loactionInfoBlock;



@end
