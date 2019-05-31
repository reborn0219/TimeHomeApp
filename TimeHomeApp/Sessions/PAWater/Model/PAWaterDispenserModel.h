//
//  PAWaterDispenserModel.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAWaterDispenserModel : NSObject

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSString *uuid;
@property (nonatomic,copy) NSString *deviceNum;
@property (nonatomic,copy) NSString *communityId;
@property (nonatomic,copy) NSString *communityName;
@property (nonatomic,copy) NSString *provinceName;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,copy) NSString *waterPrice;
@property (nonatomic,strong) NSArray *takeWaterAmount;
@end
