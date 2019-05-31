//
//  PAWaterOrderModel.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAWaterOrderModel : NSObject

@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *deviceNum;
@property (nonatomic,copy) NSString *communityName;
@property (nonatomic,copy) NSString *provinceName;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,copy) NSString *merOrderId;
@property (nonatomic,copy) NSString *waterNum;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,copy) NSString *takeWaterTime;
@property (nonatomic,copy) NSString *waterPrice;
@end
