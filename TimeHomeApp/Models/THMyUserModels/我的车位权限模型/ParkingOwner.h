//
//  ParkingOwner.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的车位权限列表model
 */
#import <Foundation/Foundation.h>

@interface ParkingOwner : NSObject
/**
 *  住宅id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  社区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 *  车位名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  服务到期时间
 */
@property (nonatomic, strong) NSString *expiretime;
/**
 *  是否驶入 0 否 1 是
 */
@property (nonatomic, strong) NSString *state;
/**
 *  驶入车辆id
 */
@property (nonatomic, strong) NSString *carid;
/**
 *  驶入车牌号
 */
@property (nonatomic, strong) NSString *card;
/**
 *  车辆备注信息
 */
@property (nonatomic, strong) NSString *carremarks;
/**
 *  权限类型：0 自用，2已出租
 */
@property (nonatomic, strong) NSString *type;
/**
 *  拥有权限的用户列表
 */
@property (nonatomic, strong) NSArray *userlist;

/**
 *新旧车库区分
 */
@property (nonatomic, strong) NSNumber *isnew;

@end
