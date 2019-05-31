//
//  CarLocationInfo.h
//  YouLifeApp
//
//  Created by us on 15/10/26.
//  Copyright © 2015年 us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarLocationInfo : NSObject

@property(nonatomic,strong) NSString *imei;//车号
@property(nonatomic,strong) NSString * device_info;//设备信息
@property(nonatomic,assign) double  lng;//经度
@property(nonatomic,assign) double  lat;//纬 度
@property(nonatomic,assign) double  direction;//方向
@property(nonatomic,strong) NSString * speed;//速度

@end
