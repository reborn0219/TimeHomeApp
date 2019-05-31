//
//  BDFWListPresenter.m
//  YouLifeApp
//
//  Created by us on 15/10/28.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BDMapFWPresenter.h"

@interface BDMapFWPresenter()
{
    
    BMKPoiSearch* _poisearch;
    BMKLocationManager* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    BOOL isStop;
}

@end

@implementation BDMapFWPresenter


///获取位置信息，经纬度，城市，街道，区，地址
-(void)getLocationInfoForupDateViewsBlock:(UpDateViewsBlock) loactionInfoBlock
{
    isStop=YES;
    if(self.location==nil)
    {
        self.location=[LocationInfo new];
    }
    self.loactionInfoBlock=loactionInfoBlock;
    [self startLocation];
}
///只获取位置
-(void)getLocationForupDateViewsBlock:(UpDateViewsBlock) loactionInfoBlock
{
    isStop=NO;
    if(self.location==nil)
    {
        self.location=[LocationInfo new];
    }
    self.loactionBlock=loactionInfoBlock;
    [self startLocation];
}


//开始定位
-(void)startLocation
{
    if (_locService==nil) {
         _locService = [[BMKLocationManager alloc]init];
    }
    _locService.delegate = self;
    [_locService startUpdatingLocation];
}
//停止定位
-(void)stopLocation
{
    [_locService stopUpdatingLocation];
    _locService.delegate = nil;
}




/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
     NSLog(@"stop locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.location.latitude=userLocation.location.coordinate.latitude;
    self.location.longitude=userLocation.location.coordinate.longitude;
    NSLog(@"lat===%f,  lng=%f",self.location.latitude,self.location.longitude);
    if(isStop)
    {
        [self stopLocation];
    }
    if(self.loactionBlock)
    {
        self.loactionBlock(self.location,SucceedCode);
    }
    if (self.loactionInfoBlock) {
        [self getLocationCityName:userLocation.location.coordinate];
    }
    
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    if(self.loactionBlock)
    {
        self.loactionBlock(@"定位失败",FailureCode);
    }
    if (self.loactionInfoBlock) {
        self.loactionInfoBlock(@"定位获取城市失败!",FailureCode);
    }

}



//搜索
-(void)seachBDData:(NSString *)KeyString centerpoint:(CLLocationCoordinate2D)location;
{
    //38.054344,  lng=114.579101
//    self.location=CLLocationCoordinate2DMake(38.054344, 114.579101);
    BMKPOINearbySearchOption *option=[[BMKPOINearbySearchOption alloc]init];
    option.location=location;
    option.keywords = @[KeyString];
    option.radius=3000;
//    option.pageIndex=self.curPage;
    if (_poisearch==nil) {
        _poisearch = [[BMKPoiSearch alloc]init];
    }
    _poisearch.delegate=self;
    BOOL flag = [_poisearch poiSearchNearBy:option];
    if(flag)
    {

        NSLog(@"搜索发送成功");
    }
    else
    {
        NSLog(@"搜索发送失败");
    }

}

-(void)dealloc
{
    _poisearch.delegate = nil;
    _locService.delegate = nil;
    _geocodesearch.delegate=nil;
}
#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult*)result errorCode:(BMKSearchErrorCode)error
{
    
//    NSString * tmp;
//    NSString * dis;
    if (error == BMK_SEARCH_NO_ERROR) {
//        for (int i = 0; i < result.poiInfoList.count; i++) {
//            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
////            dis=[self calculateLineDistanceStart:self.location endPoint:poi.pt];
////            if (poi.phone==nil) {
////                tmp=[NSString stringWithFormat:@"%@\n%@",dis,poi.address];
////            
////            }
////            else
////            {
//                tmp=[NSString stringWithFormat:@"电话:%@     %@\n%@",poi.phone==nil?@"无":poi.phone,dis,poi.address];
////            }
//            
////            poi.addr_disStr=tmp;
////            [poi calculateCell_H];
//            
//        }
//        [self.delegate SuccessShow:2000 data:result.poiInfoList];

    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
//        [self.delegate FailedShow:2001 data:@"未找到数据"];
    } else {
//        [self.delegate FailedShow:2001 data:@"未找到数据"];
    }
}




//获取定位城市名称
-(void)getLocationCityName:(CLLocationCoordinate2D)location
{
    if(_geocodesearch==nil)
    {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    }
    _geocodesearch.delegate=self;
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
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        self.location.cityName=result.addressDetail.city;
        self.location.district=result.addressDetail.district;
        self.location.addres=result.address;
        self.location.province=result.addressDetail.province;
        self.location.streetName=result.addressDetail.streetName;
        self.location.streetNumber=result.addressDetail.streetNumber;
        [UserDefaultsStorage saveData:self.location forKey:@"LocationInfo"];
        if (self.loactionInfoBlock) {
            self.loactionInfoBlock(self.location,SucceedCode);
        }
    }
    else
    {
        if (self.loactionInfoBlock) {
            self.loactionInfoBlock(@"定位获取城市失败!",FailureCode);
        }

    }
}



//地图上两点距离
+(NSString * ) calculateLineDistanceStart:(CLLocationCoordinate2D) startPoint endPoint:(CLLocationCoordinate2D) endpoint
{
    BMKMapPoint point1 = BMKMapPointForCoordinate(startPoint);
    BMKMapPoint point2 = BMKMapPointForCoordinate(endpoint);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    NSMutableString * dis;
    //    NSLog(@"distance===%f",distance);
    float gl=0.0;
    float c=10.0;
    double sss=distance;
    if (sss>1000) {
        gl=round(sss/100)/c;
        dis= [[NSMutableString alloc]initWithFormat:@"距离:%.2lf公里",gl];
        //        NSLog(@"distance=1000=dsdsd=%f",gl);
    }
    else
    {
        dis= [[NSMutableString alloc]initWithFormat:@"距离:%.2lf米",distance];
        //        NSLog(@"distance==>>dsdsd=%@",dis);
    }
    //     NSLog(@"distance==dsdsd=%@",dis);
    return dis;
    
    
}

@end
