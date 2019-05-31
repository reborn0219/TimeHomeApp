//
//  LocationInfo.h
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject
///纬度
@property(nonatomic,assign) CLLocationDegrees latitude;
///经度
@property(nonatomic,assign) CLLocationDegrees longitude;

///城市名称
@property(nonatomic,copy)NSString * cityName;
///地址
@property(nonatomic,copy)NSString * addres;

//------------------------地址详细---------------------
/// 街道号码
@property (nonatomic, copy) NSString* streetNumber;
/// 街道名称
@property (nonatomic, copy) NSString* streetName;
/// 区县名称
@property (nonatomic, copy) NSString* district;
/// 省份名称
@property (nonatomic, copy) NSString* province;


@end
