//
//  L_TimeSetInfoModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 车辆定时设置详细信息
 */
@interface L_TimeSetInfoModel : NSObject

/**
 开锁设置定时时间
 */
@property (nonatomic, strong) NSString *opentime;
/**
 锁定设置定时时间
 */
@property (nonatomic, strong) NSString *closetime;
/**
 开锁设置按钮 0为不开启  1为开启
 */
@property (nonatomic, strong) NSString *openstate;
/**
 锁定设置按钮 0为不开启  1为开启
 */
@property (nonatomic, strong) NSString *closestate;
/**
 开锁设置每周重复时间，如周一，周二，则显示为”1,2”
 */
@property (nonatomic, strong) NSString *opentimes;
/**
 锁定设置每周重复时间，如周一，周二，则显示为”1,2”
 */
@property (nonatomic, strong) NSString *closetimes;
/**
 用户id
 */
@property (nonatomic, strong) NSString *userid;
/**
 车位车辆关联id
 */
@property (nonatomic, strong) NSString *parkingcarid;

//---------自定义----------
/**
 设置是否启动定时 0为关 1为开
 */
@property (nonatomic, strong) NSNumber *lockstate;

@end
