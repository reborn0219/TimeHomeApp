//
//  L_BikeDeviceModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自行车详情感应条码
 */
@interface L_BikeDeviceModel : NSObject

/**
 感应条码id
 */
@property (nonatomic, strong) NSString *theID;

/**
 感应条码编号
 */
@property (nonatomic, strong) NSString *deviceno;

/**
 车辆类型0自行车 1电动车
 */
@property (nonatomic, strong) NSString *devicetype;

@property (nonatomic, assign) CGFloat rowHeight;

@end
